import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../states/grid_columns_provider.dart';
import '../../widgets/grid_images.dart';
import '../../widgets/no_images.dart';
import '../../widgets/pop_menu.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  final QuerySent querySent;
  final List<Photo> photos;

  const AlbumScreen({
    super.key,
    required this.querySent,
    required this.photos,
  });

  @override
  AlbumScreenState createState() => AlbumScreenState();
}

class AlbumScreenState extends ConsumerState<AlbumScreen> {
  List<Photo> photos = [];
  int page = 1;
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    page = widget.querySent.page;
    photos = widget.photos;
    photos.shuffle();
    super.initState();
  }

  void changeCrossAxisCount() {
    ref.read(gridColumnsProvider.notifier).change();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.querySent.query),
        actions: [
          IconButton(
            onPressed: changeCrossAxisCount,
            icon: const Icon(Icons.grid_view_sharp),
          ),
          const PopMenu(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : photos.isNotEmpty
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    GridImages(photos: photos),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 3.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          //color: Colors.white,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: OverflowBar(
                          spacing: 8,
                          children: [
                            IconButton(
                              onPressed:
                                  page == 1 ? null : () => searchNextPage(-1),
                              icon: Icon(
                                Icons.skip_previous,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            CircleAvatar(child: Text('$page')),
                            IconButton(
                              onPressed:
                                  isLastPage ? null : () => searchNextPage(1),
                              icon: Icon(
                                Icons.skip_next,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const NoImages(message: 'Images not found'),
    );
  }

  Future<void> searchNextPage(int newPage) async {
    setState(() {
      isLoading = true;
      page = page + newPage;
    });

    // COMPROBAR SI EL SERVER TIENE PARAMETRO PAGE
    final List<Photo> photosNext = await RequestApi(
      querySent: QuerySent(
        query: widget.querySent.query,
        page: page,
        filter: widget.querySent.filter,
      ),
    ).searchPhotos;

    if (photosNext.isEmpty) {
      setState(() => isLastPage = true);
    }
    setState(() {
      photos = photosNext;
      isLoading = false;
    });
  }
}

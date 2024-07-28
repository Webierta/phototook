import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/photo.dart';
import '../../data/models/query_sent.dart';
import '../../data/models/request_api.dart';
import '../../utils/globals.dart';
import '../screens/album/album_screen.dart';
import '../screens/single_photo/single_photo_screen.dart';
import '../states/filter_provider.dart';
import 'cached_image.dart';
import 'show_info.dart';

class CardView extends ConsumerStatefulWidget {
  final List<Photo> photos;
  const CardView({super.key, required this.photos});

  @override
  CardViewState createState() => CardViewState();
}

class CardViewState extends ConsumerState<CardView> {
  bool isLoading = false;

  Future<void> searchQuery(String query) async {
    if (query.trim().isEmpty) {
      return;
    }
    setState(() => isLoading = true);
    final filter = ref.watch(filterProvider);
    QuerySent querySent = QuerySent(query: query, page: 1, filter: filter);
    await RequestApi(querySent: querySent)
        .searchPhotos
        .then((List<Photo> fotos) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  AlbumScreen(querySent: querySent, photos: fotos),
            ),
            ModalRoute.withName('/home')))
        .catchError((onError) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      // scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      return scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(l10n.cardViewError)),
      );
    }).whenComplete(() {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          final Photo photo = widget.photos[index];
          final image = CachedImage(
            photo: photo,
            fit: BoxFit.cover,
          );
          showInfo(InfoAttribute attribute) => ShowInfo(
                photo: photo,
                attribute: attribute,
                searchQuery:
                    attribute == InfoAttribute.tags ? searchQuery : null,
              );

          return SizedBox(
            height: 400,
            width: double.infinity,
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: double.infinity,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    SinglePhotoScreen(photo: photo),
                              ),
                            );
                          },
                          child: image),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            showInfo(InfoAttribute.author),
                            showInfo(InfoAttribute.link),
                            showInfo(InfoAttribute.size),
                            showInfo(InfoAttribute.title),
                            showInfo(InfoAttribute.description),
                            showInfo(InfoAttribute.license),
                            showInfo(InfoAttribute.tags),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

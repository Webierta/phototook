import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/filter_request.dart';
import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../../utils/local_storage.dart';
import '../../states/filter_provider.dart';
import '../../widgets/pop_menu.dart';
import '../single_photo/single_photo_screen.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  final QuerySent querySent;
  final List<Photo> photos;
  const AlbumScreen({super.key, required this.querySent, required this.photos});

  @override
  AlbumScreenState createState() => AlbumScreenState();
}

class AlbumScreenState extends ConsumerState<AlbumScreen> {
  List<Photo> photos = [];
  int crossAxisCount = 3;
  double aspectRatio = 1.0;
  int page = 1;
  bool isLastPage = false;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    page = widget.querySent.page;
    photos = widget.photos;
    photos.shuffle();
    fetchImagesFromAPI();
    loadSharedPrefs();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadSharedPrefs() async {
    final LocalStorage sharedPrefs = LocalStorage();
    await sharedPrefs.init();
    setState(() {
      crossAxisCount = sharedPrefs.albumColumns;
    });
  }

  Future<void> fetchImagesFromAPI() async {
    Map<String, String> mapIdUrl = {};
    for (var photo in photos) {
      if (photo.id.trim().isNotEmpty && photo.url.trim().isNotEmpty) {
        mapIdUrl[photo.id] = photo.url;
      }
    }
    if (photos.isNotEmpty && photos.length == mapIdUrl.entries.length) {
      await downloadImagesToCache(mapIdUrl);
      //compute(downloadImagesToCache, mapIdUrl);
    } // ELSE ERROR
    //setState(() => isLoading = false);
  }

  Future<void> downloadImagesToCache(Map<String, String> mapIdUrl) async {
    await Future.forEach(mapIdUrl.entries, (entry) async {
      bool fileExists = FastCachedImageConfig.isCached(imageUrl: entry.value);
      if (!fileExists) {
        try {
          FastCachedImage(url: entry.value, key: Key(entry.key));
        } catch (e) {
          //print('Error in downloading image $e');
        }
      }
    }).timeout(const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = ref.watch(filterProvider).orientation;
    if (orientation != null) {
      aspectRatio = switch (orientation) {
        OrientationFilter.landscape => 1.8,
        OrientationFilter.portrait => 0.8,
        OrientationFilter.squarish => 1,
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.querySent.query),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                crossAxisCount++;
                if (crossAxisCount > 6) {
                  crossAxisCount = 1;
                }
              });
            },
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
                    CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 1.0,
                            crossAxisSpacing: 1.0,
                            childAspectRatio: aspectRatio,
                          ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];
                            final image = FastCachedImage(
                              key: Key(photo.id),
                              url: photo.url,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, progress) {
                                return Container(
                                  color: Colors.white70,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (progress.isDownloading &&
                                          progress.totalBytes != null)
                                        Text(
                                          '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                          style: const TextStyle(
                                            color: Colors.white30,
                                          ),
                                        ),
                                      CircularProgressIndicator(
                                        color: Colors.white30,
                                        value:
                                            progress.progressPercentage.value,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              errorBuilder: (context, exception, stacktrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            );
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SinglePhotoScreen(photo: photo),
                                  ),
                                );
                              },
                              child: image,
                            );
                          },
                        ),
                      ],
                    ),
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
              : Center(
                  child: LayoutBuilder(builder: (context, constraint) {
                    return SizedBox(
                      height: constraint.biggest.height,
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            'Images not found',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Expanded(
                            child: Icon(
                              Icons.image_not_supported,
                              size: constraint.maxHeight / 2,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    );
                  }),
                ),
    );
  }

  Future<void> searchNextPage(int newPage) async {
    scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut, // Curves.fastOutSlowIn
    );

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

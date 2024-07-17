import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phototook/ui/states/grid_columns_provider.dart';

import '../../data/models/filter_request.dart';
import '../../data/models/photo.dart';
import '../../utils/local_storage.dart';
import '../screens/single_photo/single_photo_screen.dart';
import '../states/filter_provider.dart';
import 'cached_image.dart';

class GridImages extends ConsumerStatefulWidget {
  final List<Photo> photos;

  const GridImages({super.key, required this.photos});

  @override
  GridImagesState createState() => GridImagesState();
}

class GridImagesState extends ConsumerState<GridImages> {
  int crossAxisCount = 3;
  double aspectRatio = 1.0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
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
    for (var photo in widget.photos) {
      if (photo.id.trim().isNotEmpty && photo.url.trim().isNotEmpty) {
        mapIdUrl[photo.id] = photo.url;
      }
    }
    if (widget.photos.isNotEmpty &&
        widget.photos.length == mapIdUrl.entries.length) {
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
    crossAxisCount = ref.watch(gridColumnsProvider);
    List<Photo> photos = widget.photos;
    final orientation = ref.watch(filterProvider).orientation;
    if (orientation != null) {
      aspectRatio = switch (orientation) {
        OrientationFilter.landscape => 1.8,
        OrientationFilter.portrait => 0.8,
        OrientationFilter.squarish => 1,
      };
    }
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: aspectRatio,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            final image = CachedImage(
              photo: photo,
              fit: BoxFit.cover,
            );
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SinglePhotoScreen(photo: photo),
                  ),
                );
              },
              child: image,
            );
          },
        ),
      ],
    );
  }
}

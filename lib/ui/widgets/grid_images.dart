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
            return GestureDetector(
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

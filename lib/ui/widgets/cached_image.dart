import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/photo.dart';
import 'no_images.dart';

class CachedImage extends StatelessWidget {
  final Photo photo;
  final BoxFit fit;
  const CachedImage({super.key, required this.photo, required this.fit});

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      key: Key(photo.id),
      url: photo.url,
      width: double.infinity, // ??
      fit: fit,
      loadingBuilder: (context, progress) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (progress.isDownloading && progress.totalBytes != null)
              Text(
                '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
              value: progress.progressPercentage.value,
            ),
          ],
        );
      },
      errorBuilder: (context, exception, stacktrace) {
        return const NoImages(message: 'Image not found');
      },
    );
  }
}

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/photo.dart';

class CachedImage extends StatelessWidget {
  final Photo photo;
  final BoxFit fit;
  const CachedImage({
    super.key,
    required this.photo,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      key: Key(photo.id),
      url: photo.url,
      width: double.infinity, // ??
      fit: fit,
      loadingBuilder: (context, progress) {
        return Container(
          color: Colors.white70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (progress.isDownloading && progress.totalBytes != null)
                Text(
                  '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                  style: const TextStyle(
                    color: Colors.white30,
                  ),
                ),
              CircularProgressIndicator(
                color: Colors.white30,
                value: progress.progressPercentage.value,
              ),
            ],
          ),
        );
      },
      /* errorBuilder: (context, exception, stacktrace) {
        return const Icon(Icons.image_not_supported);
      }, */
      errorBuilder: (context, exception, stacktrace) {
        return LayoutBuilder(builder: (context, constraint) {
          return SizedBox(
            height: constraint.biggest.height,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'Image not found',
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
        });
      },
    );
  }
}

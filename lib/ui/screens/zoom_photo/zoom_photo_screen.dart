import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/photo.dart';
import '../../widgets/no_images.dart';

class ZoomPhotoScreen extends StatelessWidget {
  final Photo photo;
  const ZoomPhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    String url = photo.linkDownload ??
        photo.urlHD ??
        photo.urlMD ??
        photo.urlLD ??
        photo.url;

    return Center(
      child: Stack(
        children: [
          if (url.isEmpty)
            const NoImages(
              message:
                  'Invalid image data.\nThis URL is invalid or has expired.',
            )
          else
            SizedBox.expand(
              child: InteractiveViewer(
                constrained: true,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.1,
                maxScale: 5.5,
                child: FastCachedImage(
                  url: url,
                  //width: MediaQuery.of(context).size.width,
                  errorBuilder: (context, exception, stacktrace) {
                    return const NoImages(
                      message:
                          'Invalid image data.\nThis URL is invalid or has expired.',
                    );
                  },
                ),
              ),
            ),
          Positioned(
            left: 14,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const CircleAvatar(
                child: Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

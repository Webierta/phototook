import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/photo.dart';

class FullPhotoScreen extends StatelessWidget {
  final Photo photo;
  const FullPhotoScreen({super.key, required this.photo});

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
          SizedBox.expand(
            child: InteractiveViewer(
              constrained: true,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              minScale: 0.1,
              maxScale: 4.0,
              child: FastCachedImage(
                url: url,
                //width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Positioned(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
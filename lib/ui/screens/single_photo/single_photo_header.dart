//import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/photo.dart';
import '../../../data/models/server.dart';
import '../../../utils/consts.dart';
import '../../../utils/globals.dart' as globals;

class SinglePhotoHeader extends StatelessWidget {
  final Photo photo;
  const SinglePhotoHeader({super.key, required this.photo});

  Future<void> _launchUrl(String url) async {
    const String utmParameters = '?utm_source=$appName&utm_medium=referral';
    Uri uri =
        Uri.parse(photo.server == Server.unsplash ? '$url$utmParameters' : url);
    if (!await launchUrl(uri)) {
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  ImageProvider<Object> getAvatar(String url) {
    try {
      final image = NetworkImage(url);
      return image;
    } catch (e) {
      return const AssetImage('assets/user_avatar.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 4,
      titleAlignment: ListTileTitleAlignment.top,
      leading: CircleAvatar(
        radius: 30,
        backgroundImage:
            (photo.authorImage == null || photo.authorImage!.isEmpty)
                ? null
                : getAvatar(photo.authorImage!),
        child: (photo.authorImage == null || photo.authorImage!.isEmpty)
            ? const Icon(Icons.person)
            : null,
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: photo.authorUrl == null
            ? Text('By ${photo.author}')
            : RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'By ',
                      style: Theme.of(context).textTheme.headlineSmall!,
                    ),
                    TextSpan(
                      text: photo.author,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchUrl(photo.authorUrl!),
                    ),
                  ],
                ),
              ),
      ),
      //subtitle: Text('on ${photo.server.name.toUpperCase()}'),
      // https://unsplash.com/?utm_source=your_app_name&utm_medium=referral
      subtitle: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'on ',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            TextSpan(
              text: photo.server.name.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchUrl(photo.server.url),
            ),
          ],
        ),
      ),
      /* trailing: ElevatedButton.icon(
        onPressed: downloadImage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        label: const Icon(Icons.file_download),
      ), */
    );
  }
}

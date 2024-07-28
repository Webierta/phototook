import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/photo.dart';
import '../../data/models/server.dart';
import '../../utils/consts.dart';
import '../../utils/globals.dart';

enum InfoAttribute { author, link, title, description, size, license, tags }

class ShowInfo extends StatelessWidget {
  final Photo photo;
  final InfoAttribute attribute;
  final Function(String)? searchQuery;

  const ShowInfo({
    super.key,
    required this.photo,
    required this.attribute,
    this.searchQuery,
  });

  Future<void> _launchUrl(String url) async {
    //?? parametros para todos los enlaces de unsplash ??
    const String utmParameters = '?utm_source=$appName&utm_medium=referral';
    Uri uri =
        Uri.parse(photo.server == Server.unsplash ? '$url$utmParameters' : url);
    if (!await launchUrl(uri)) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  ImageProvider? getAvatar() {
    if (photo.authorImage == null || photo.authorImage!.isEmpty) {
      return null;
    }
    try {
      final image = NetworkImage(photo.authorImage!);
      return image;
    } catch (e) {
      return const AssetImage('assets/user_avatar.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (attribute == InfoAttribute.author) {
      return ListTile(
        dense: true,
        //horizontalTitleGap: 4,
        titleAlignment: ListTileTitleAlignment.top,
        leading: CircleAvatar(
          //radius: 20, // 30
          backgroundImage: getAvatar(),
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
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
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
      );
    }
    if (attribute == InfoAttribute.link &&
        (photo.link != null && photo.link!.isNotEmpty)) {
      return ListTile(
        dense: true,
        leading: const Icon(Icons.link),
        title: GestureDetector(
          onTap: () => _launchUrl(photo.link!),
          child: Text(
            (photo.source != null && photo.source!.isNotEmpty)
                ? 'Website (source: ${photo.source!.toUpperCase()})'
                : 'Website',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      );
    }
    if (attribute == InfoAttribute.title &&
        (photo.title != null && photo.title!.trim().isNotEmpty)) {
      return ListTile(
        dense: true,
        titleAlignment: ListTileTitleAlignment.top,
        leading: const Icon(Icons.title),
        title: Text(photo.title!),
      );
    }
    if (attribute == InfoAttribute.description &&
        (photo.description != null &&
            photo.description!.trim().isNotEmpty &&
            photo.description != photo.title)) {
      return ListTile(
        dense: true,
        //horizontalTitleGap: 4,
        titleAlignment: ListTileTitleAlignment.top,
        leading: const Icon(Icons.message),
        title: Text(photo.description!),
      );
    }
    if (attribute == InfoAttribute.size) {
      return ListTile(
        dense: true,
        leading: const Icon(Icons.photo_size_select_large),
        title: Text('Original size: W ${photo.width} x H ${photo.height} px'),
      );
    }
    if (attribute == InfoAttribute.license &&
        (photo.license != null && photo.license!.isNotEmpty)) {
      return ListTile(
        dense: true,
        leading: const Icon(Icons.security),
        title: Text('License: ${photo.license}'),
      );
    }
    if (attribute == InfoAttribute.tags &&
        (photo.tags != null && photo.tags!.isNotEmpty)) {
      return ListTile(
        dense: true,
        titleAlignment: ListTileTitleAlignment.top,
        leading: const Icon(Icons.label),
        title: Wrap(
          runSpacing: 8,
          spacing: 8,
          children: photo.tags!.map((tag) {
            return ActionChip(
              label: Text(tag),
              labelStyle: Theme.of(context).textTheme.labelSmall,
              //!.copyWith(color: Theme.of(context).colorScheme.secondary),
              //labelPadding: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                searchQuery!(tag);
              },
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

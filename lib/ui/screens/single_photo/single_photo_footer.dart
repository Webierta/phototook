import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/photo.dart';
import '../../../utils/globals.dart' as globals;

class SinglePhotoFooter extends StatelessWidget {
  final Photo photo;
  final Function(String) searchQuery;
  const SinglePhotoFooter(
      {super.key, required this.photo, required this.searchQuery});

  Future<void> _launchUrl(String url) async {
    //const String utmParameters = '?utm_source=$appName&utm_medium=referral';
    //Uri uri = Uri.parse(photo.server == Server.unsplash ? '$url$utmParameters' : url);
    if (!await launchUrl(Uri.parse(url))) {
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //shape: const CircularNotchedRectangle(),
      //notchMargin: 5,
      height: 45,
      color: Theme.of(context).colorScheme.inversePrimary,
      //color: Colors.transparent,
      //elevation: 0,
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (photo.link != null &&
                              photo.link!.trim().isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.link),
                              title: InkWell(
                                onTap: () => _launchUrl(photo.link!),
                                child: Text(
                                  (photo.source != null &&
                                          photo.source!.isNotEmpty)
                                      ? 'Website (source: ${photo.source!.toUpperCase()})'
                                      : 'Website',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          if (photo.title != null &&
                              photo.title!.trim().isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.title),
                              title: Text(photo.title!),
                            ),
                          if (photo.description != null &&
                              photo.description!.trim().isNotEmpty &&
                              photo.description != photo.title)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.message),
                              title: Text(photo.description!),
                            ),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.photo_size_select_large),
                            title: Text(
                                'Original Size: W ${photo.width} x H ${photo.height} px'),
                          ),
                          if (photo.license != null)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.security),
                              title: Text('License: ${photo.license}'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.info),
          ),
          if (photo.tags != null && photo.tags!.isNotEmpty)
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      height: 200,
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 8,
                          spacing: 8,
                          children: photo.tags!.map((tag) {
                            return ActionChip(
                              label: Text(tag),
                              labelStyle:
                                  Theme.of(context).textTheme.labelLarge,
                              labelPadding: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(0),
                              onPressed: () async {
                                //Navigator.pop(context); //ERROR ??
                                Navigator.pop(context);
                                searchQuery(tag);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.label),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../data/models/photo.dart';
import '../../widgets/show_info.dart';
import '../zoom_photo/zoom_photo_screen.dart';

class SinglePhotoFooter extends StatelessWidget {
  final Photo photo;
  final Function(String) searchQuery;
  const SinglePhotoFooter(
      {super.key, required this.photo, required this.searchQuery});

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
                  showInfo(InfoAttribute attribute) => ShowInfo(
                        photo: photo,
                        attribute: attribute,
                        searchQuery: attribute == InfoAttribute.tags
                            ? searchQuery
                            : null,
                      );
                  return Container(
                    padding: const EdgeInsets.all(12),
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          showInfo(InfoAttribute.link),
                          showInfo(InfoAttribute.title),
                          showInfo(InfoAttribute.description),
                          showInfo(InfoAttribute.size),
                          showInfo(InfoAttribute.license),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ZoomPhotoScreen(photo: photo),
                ),
              );
            },
            icon: const Icon(Icons.zoom_in),
          )
        ],
      ),
    );
  }
}

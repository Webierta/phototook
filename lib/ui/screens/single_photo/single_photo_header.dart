//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/photo.dart';
import '../../../data/models/server.dart';
import '../../../utils/consts.dart';
import '../../../utils/globals.dart' as globals;
import '../../widgets/show_info.dart';

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
    return ShowInfo(
      photo: photo,
      attribute: InfoAttribute.author,
    );
  }
}

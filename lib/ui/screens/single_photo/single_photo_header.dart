import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/apis/unsplash/unsplash_download.dart';
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

  Future<void> downloadImage() async {
    if (photo.linkDownload == null) {
      showResultDownload(isResponseOk: false);
      return;
    }

    String url = photo.linkDownload!;
    if (photo.server == Server.unsplash) {
      final client = Client();
      final unsplashDownload = UnsplashDownload(id: photo.id);
      if (unsplashDownload.authorization == false) {
        print('autorizacion error');
        return;
      }

      final response = await client.get(
        unsplashDownload.uriDownload,
        headers: unsplashDownload.headers,
      );
      if (response.statusCode != 200) {
        print('status code error');
        return;
      }
      try {
        final download = Download.fromJson(json.decode(response.body));
        url = download.url;
      } catch (e) {
        print(e.toString());
        return;
      } finally {
        client.close();
      }
    }

    Directory directory = Directory('');
    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory());
    } else {
      //directory = (await getApplicationCacheDirectory());
      directory = (await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory());
    }
    //String format = getFormat(url);
    //String savePath = '${directory.path}/${photo.id}.$format';
    String savePath = '${directory.path}/${photo.id}';
    await Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
    ))
        .download(url, savePath)
        .then((value) => showResultDownload(
              isResponseOk: true,
              savePath: savePath,
            ))
        //.onError((handleError) => )
        .catchError((error) => showResultDownload(isResponseOk: false));
  }

  void showResultDownload({bool? isResponseOk, String? savePath}) {
    String content = 'Error downloading image';
    if (isResponseOk == true) {
      content = savePath != null
          ? 'Image downloaded at $savePath'
          : 'Download process aborted. The license may not support direct download';
    }
    globals.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(content: Text(content)),
    );
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
      trailing: ElevatedButton.icon(
        onPressed: downloadImage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        label: const Icon(Icons.file_download),
      ),
    );
  }
}

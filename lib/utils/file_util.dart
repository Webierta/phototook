import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/apis/unsplash/unsplash_download.dart';
import '../data/models/photo.dart';
import '../data/models/server.dart';
import 'globals.dart';

class FileUtil {
  static String? getFileName(Photo photo) {
    if (photo.filetype == null || photo.filetype!.isEmpty) {
      return null;
    }
    return '${photo.id}.${photo.filetype}';
  }

  static showSnackBar(String content) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(content)),
    );
  }

  static Future<void> download(Photo photo) async {
    final fileName = getFileName(photo);
    if (fileName == null) {
      showSnackBar(l10n.singleFiletypeError);
      return;
    }
    if (photo.linkDownload == null) {
      showSnackBar(l10n.singleDownloadLinkNotFound);
      return;
    }
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: fileName,
    );

    if (savePath == null) {
      showSnackBar(l10n.singleDownloadCancel);
      return;
    }

    String url = photo.linkDownload!;
    final Client client = Client();

    if (photo.server == Server.unsplash) {
      final unsplashDownload = UnsplashDownload(id: photo.id);
      if (unsplashDownload.authorization == false) {
        showSnackBar(l10n.singleAuthorizationFailed);
        client.close();
        return;
      }

      try {
        final response = await client.get(
          unsplashDownload.uriDownload,
          headers: unsplashDownload.headers,
        );
        if (response.statusCode != 200) {
          showSnackBar(l10n.singleServerFailed);
          client.close();
          return;
        }
        final download = Download.fromJson(json.decode(response.body));
        url = download.url;
      } catch (e) {
        showSnackBar(l10n.singleErrorDownloading(e.toString()));
        client.close();
        return;
      }
    }

    try {
      await client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5))
          .then((response) {
        if (response.statusCode == 200) {
          File(savePath).writeAsBytes(response.bodyBytes);
          showSnackBar(l10n.singleDownloadedAt(savePath));
        } else {
          showSnackBar(l10n.singleServerFailed);
          return;
        }
      });
    } catch (e) {
      showSnackBar(l10n.singleErrorDownloading(e.toString()));
    } finally {
      client.close();
    }
  }

  static Future<void> shared(Photo photo) async {
    final fileName = getFileName(photo);
    if (fileName == null) {
      showSnackBar(l10n.singleFiletypeError);
      return;
    }
    if (photo.linkDownload == null) {
      showSnackBar(l10n.singleDownloadLinkNotFound);
      return;
    }

    if (Platform.isAndroid) {
      final directory = await getApplicationCacheDirectory();
      final savePath = '${directory.path}/$fileName';
      final Client client = Client();
      File? file;
      try {
        final response = await client.get(Uri.parse(photo.linkDownload!));
        if (response.statusCode == 200) {
          file = await File(savePath).writeAsBytes(response.bodyBytes);
          final XFile xFile = XFile(file.path);
          await Share.shareXFiles(
            [xFile],
            //text: l10n.singleGreatPicture(appName),
            text: fileName,
          );
          //file.delete();
        } else {
          showSnackBar(l10n.singleServerFailed);
          return;
        }
      } catch (e) {
        showSnackBar(l10n.singleErrorDownloading(e.toString()));
        return;
      } finally {
        client.close();
        file?.delete();
      }
    } else {
      await Share.share(
        '${photo.linkDownload}',
        //subject: l10n.singleGreatPicture(appName),
        subject: fileName,
      );
    }
    //print('resultado:${result.status}');
    /* if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
      //file?.delete();
    } */
  }
}

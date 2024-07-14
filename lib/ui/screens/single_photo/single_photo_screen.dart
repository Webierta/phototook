import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../../utils/globals.dart' as globals;
import '../../widgets/pop_menu.dart';
import '../album/album_screen.dart';
import 'full_photo_screen.dart';
import 'single_photo_header.dart';

class SinglePhotoScreen extends ConsumerStatefulWidget {
  final Photo photo;
  const SinglePhotoScreen({super.key, required this.photo});
  @override
  SinglePhotoScreenState createState() => SinglePhotoScreenState();
}

class SinglePhotoScreenState extends ConsumerState<SinglePhotoScreen> {
  bool isLoading = false;

  Future<void> _launchUrl(String url) async {
    //const String utmParameters = '?utm_source=$appName&utm_medium=referral';
    //Uri uri = Uri.parse(photo.server == Server.unsplash ? '$url$utmParameters' : url);
    if (!await launchUrl(Uri.parse(url))) {
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> shareImage() async {
    if (widget.photo.linkDownload == null) {
      return;
    }
    ShareResult? result;
    if (Platform.isAndroid) {
      final directory = await getApplicationCacheDirectory();
      final savePath = '${directory.path}/${widget.photo.id}';
      await Dio(
        BaseOptions(connectTimeout: const Duration(seconds: 5)),
      ).download(widget.photo.linkDownload!, savePath);
      final file = XFile(savePath);
      result = await Share.shareXFiles(
        [file],
        text: 'Great picture',
      );
    } else {
      result = await Share.share(
        '${widget.photo.linkDownload}',
        subject: 'Great picture',
      );
    }
    if (result.status == ShareResultStatus.success) {
      //print('Thank you for sharing the picture!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> searchQuery(String query) async {
      if (query.trim().isEmpty) {
        return;
      }
      setState(() => isLoading = true);
      QuerySent querySent = QuerySent(query: query, page: 1);
      await RequestApi(querySent: querySent)
          .searchPhotos
          .then((List<Photo> fotos) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => AlbumScreen(
                  querySent: querySent,
                  photos: fotos,
                ),
              ),
              ModalRoute.withName('/home')))
          .catchError((onError) =>
              globals.scaffoldMessengerKey.currentState!.showSnackBar(
                const SnackBar(content: Text('Error searching for photos')),
              ))
          .whenComplete(() {
        if (mounted) {
          setState(() => isLoading = false);
        }
      });
    }

    Photo photo = widget.photo;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(
                photo.title ?? 'No Title',
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              actions: const [PopMenu()],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SinglePhotoHeader(photo: photo),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullPhotoScreen(photo: photo),
                          ),
                        );
                      },
                      child: FastCachedImage(
                        url: photo.url,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, exception, stacktrace) {
                          return LayoutBuilder(builder: (context, constraint) {
                            return SizedBox(
                              height: constraint.biggest.height,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  Text(
                                    'Image not found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            bottomNavigationBar: Hero(
              tag: 'Bottom Bar',
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                height: 60,
                //color: Colors.transparent,
                color: Theme.of(context).colorScheme.inversePrimary,
                elevation: 0,
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
                                            style: const TextStyle(
                                                color: Colors.blue),
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
                                      leading: const Icon(
                                          Icons.photo_size_select_large),
                                      title: Text(
                                          'Original Size: W ${photo.width} x H ${photo.height} px'),
                                    ),
                                    if (photo.license != null)
                                      ListTile(
                                        dense: true,
                                        leading: const Icon(Icons.security),
                                        title:
                                            Text('License: ${photo.license}'),
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
                                padding: const EdgeInsets.all(14),
                                height: 200,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runSpacing: 8,
                                    spacing: 8,
                                    children: photo.tags!.map((tag) {
                                      return ActionChip(
                                        label: Text(tag),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
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
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
              heroTag: 'single_photo',
              onPressed: shareImage,
              shape: const CircleBorder(),
              child: const Icon(Icons.share),
            ),
          );
  }
}
/* 
class HeadSinglePhoto extends StatelessWidget {
  final Photo photo;
  const HeadSinglePhoto({super.key, required this.photo});

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
      return;
    }

    String url = photo.linkDownload!;
    if (photo.server == Server.unsplash) {
      final response = await UnsplashRequest().photoDownload(id: photo.id);
      if (response == null || response.statusCode != 200) {
        return;
      } else if (response.statusCode == 200) {
        final download = Download.fromJson(json.decode(response.body));
        if (download.url.trim().isNotEmpty) {
          url = download.url;
        }
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.secondary),
                    ),
                    TextSpan(
                      text: photo.author,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.blue,
                                //decoration: TextDecoration.underline,
                              ),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          TextSpan(
            text: photo.server.name.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.blue,
                  //decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(photo.server.url),
          ),
        ],
      )),
      trailing: ElevatedButton(
        //onPressed: () => getUrlDownload(photo.id!),
        onPressed: downloadImage,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white, // Splash color
        ),
        child: const Icon(Icons.file_download),
      ),
    );
  }
}
 */

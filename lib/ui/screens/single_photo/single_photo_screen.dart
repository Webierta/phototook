import 'dart:convert';
import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/apis/unsplash/unsplash_download.dart';
import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../../data/models/server.dart';
import '../../../utils/globals.dart' as globals;
import '../../states/filter_provider.dart';
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

  Future<void> downloadImage() async {
    if (widget.photo.linkDownload == null) {
      showResultDownload(
        isResponseOk: false,
        message: 'Download link not found',
      );
      return;
    }

    Directory directory = Directory('');
    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory());
    } else {
      directory = (await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory());
    }
    String savePath = '${directory.path}/${widget.photo.id}';

    String url = widget.photo.linkDownload!;
    final Client client = Client();

    if (widget.photo.server == Server.unsplash) {
      final unsplashDownload = UnsplashDownload(id: widget.photo.id);
      if (unsplashDownload.authorization == false) {
        showResultDownload(
          isResponseOk: false,
          message: 'authorization failed',
        );
        client.close();
        return;
      }
      final response = await client.get(
        unsplashDownload.uriDownload,
        headers: unsplashDownload.headers,
      );
      if (response.statusCode != 200) {
        showResultDownload(
          isResponseOk: false,
          message: 'server response failed',
        );
        client.close();
        return;
      }
      try {
        final download = Download.fromJson(json.decode(response.body));
        url = download.url;
      } catch (e) {
        showResultDownload(isResponseOk: false, message: e.toString());
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
          showResultDownload(isResponseOk: true, message: savePath);
        } else {
          showResultDownload(
            isResponseOk: false,
            message: 'server response failed',
          );
        }
      });
    } catch (error) {
      showResultDownload(isResponseOk: false, message: error.toString());
    } finally {
      client.close();
    }
  }

  void showResultDownload({bool? isResponseOk, String? message}) {
    String content = 'Error downloading image: $message';
    if (isResponseOk == true) {
      content = message != null
          ? 'Image downloaded at $message'
          : 'Download process aborted. The license may not support direct download';
    }
    globals.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(content: Text(content)),
    );
  }

  Future<void> shareImage() async {
    if (widget.photo.linkDownload == null) {
      return;
    }
    ShareResult? result;
    File? file;
    if (Platform.isAndroid) {
      final directory = await getApplicationCacheDirectory();
      final savePath = '${directory.path}/${widget.photo.id}';
      /* await Dio(
        BaseOptions(connectTimeout: const Duration(seconds: 5)),
      ).download(widget.photo.linkDownload!, savePath); */
      final Client client = Client();
      final response = await client.get(Uri.parse(widget.photo.linkDownload!));
      client.close();
      if (response.statusCode == 200) {
        file = await File(savePath).writeAsBytes(response.bodyBytes);
        final XFile xFile = XFile(file.path);
        result = await Share.shareXFiles([xFile], text: 'Great picture');
        file.delete();
      } else {
        return;
      }
    } else {
      result = await Share.share(
        '${widget.photo.linkDownload}',
        subject: 'Great picture',
      );
    }
    print('resultado:${result.status}');
    if (result.status == ShareResultStatus.success) {
      //print('Thank you for sharing the picture!');
      //file?.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> searchQuery(String query) async {
      if (query.trim().isEmpty) {
        return;
      }
      setState(() => isLoading = true);
      final filter = ref.watch(filterProvider);
      QuerySent querySent = QuerySent(query: query, page: 1, filter: filter);
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
        : Stack(
            children: [
              Scaffold(
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
                                builder: (context) =>
                                    FullPhotoScreen(photo: photo),
                              ),
                            );
                          },
                          child: FastCachedImage(
                            url: photo.url,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, exception, stacktrace) {
                              return LayoutBuilder(
                                  builder: (context, constraint) {
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
                      //const SizedBox(height: 4),
                    ],
                  ),
                ),
                bottomNavigationBar: Hero(
                  tag: 'Bottom Bar',
                  child: BottomAppBar(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (photo.link != null &&
                                            photo.link!.trim().isNotEmpty)
                                          ListTile(
                                            dense: true,
                                            leading: const Icon(Icons.link),
                                            title: InkWell(
                                              onTap: () =>
                                                  _launchUrl(photo.link!),
                                              child: Text(
                                                (photo.source != null &&
                                                        photo
                                                            .source!.isNotEmpty)
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
                                            photo.description!
                                                .trim()
                                                .isNotEmpty &&
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
                                            title: Text(
                                                'License: ${photo.license}'),
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
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                            labelPadding:
                                                const EdgeInsets.all(4),
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
              ),
              Positioned(
                right: 14,
                bottom: 25,
                child: Row(
                  children: [
                    FloatingActionButton.small(
                      heroTag: null,
                      onPressed: downloadImage,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.download),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton.small(
                      heroTag: null,
                      onPressed: shareImage,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.share),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

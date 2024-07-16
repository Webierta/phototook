import 'dart:convert';
import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/apis/unsplash/unsplash_download.dart';
import '../../../data/models/favorite.dart';
import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../../data/models/server.dart';
import '../../../utils/globals.dart' as globals;
import '../../../utils/local_storage.dart';
import '../../states/filter_provider.dart';
import '../../widgets/pop_menu.dart';
import '../album/album_screen.dart';
import '../full_photo/full_photo_screen.dart';
import 'single_photo_footer.dart';
import 'single_photo_header.dart';

class SinglePhotoScreen extends ConsumerStatefulWidget {
  final Photo photo;
  const SinglePhotoScreen({super.key, required this.photo});
  @override
  SinglePhotoScreenState createState() => SinglePhotoScreenState();
}

class SinglePhotoScreenState extends ConsumerState<SinglePhotoScreen> {
  bool isLoading = false;
  bool isFavorite = false;
  final LocalStorage sharedPrefs = LocalStorage();

  @override
  void initState() {
    loadSharedPrefs();
    checkFavorite();
    super.initState();
  }

  Future<void> loadSharedPrefs() async {
    await sharedPrefs.init();
  }

  void checkFavorite() {
    Favorite favorite = Favorite.fromPhoto(widget.photo);
    Map<String, dynamic> favoriteJson = favorite.toJson();
    final String favoriteEncode = jsonEncode(favoriteJson);
    //final LocalStorage sharedPrefs = LocalStorage();
    //await sharedPrefs.init();
    List<String> listaFavoritos = sharedPrefs.favoritesPhotos;
    if (listaFavoritos.contains(favoriteEncode)) {
      setState(() => isFavorite = true);
    } else {
      setState(() => isFavorite = false);
    }
  }

  void favoriteImage() async {
    Favorite favorite = Favorite.fromPhoto(widget.photo);

    // SAVE TO OUR LOCAL STORAGE
    Map<String, dynamic> favoriteJson = favorite.toJson();
    final String favoriteEncode = jsonEncode(favoriteJson);

    //final LocalStorage sharedPrefs = LocalStorage();
    //await sharedPrefs.init();
    List<String> listaFavoritos = sharedPrefs.favoritesPhotos;
    if (!listaFavoritos.contains(favoriteEncode)) {
      listaFavoritos.add(favoriteEncode);
      sharedPrefs.favoritesPhotos = listaFavoritos;
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Favorite add')),
      );
    } else {
      listaFavoritos.remove(favoriteEncode);
      sharedPrefs.favoritesPhotos = listaFavoritos;
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Favorite delete')),
      );
    }
    checkFavorite();
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

  @override
  Widget build(BuildContext context) {
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
                  child: SinglePhotoFooter(
                    photo: photo,
                    searchQuery: searchQuery,
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
                      onPressed: favoriteImage,
                      shape: const CircleBorder(),
                      child: isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_outline),
                    ),
                    const SizedBox(width: 12),
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

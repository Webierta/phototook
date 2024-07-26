import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/favorite.dart';
import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../../utils/file_util.dart';
import '../../../utils/globals.dart' as globals;
import '../../../utils/local_storage.dart';
import '../../states/filter_provider.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/pop_menu.dart';
import '../../widgets/show_info.dart';
import '../album/album_screen.dart';
import '../zoom_photo/zoom_photo_screen.dart';
import 'single_photo_footer.dart';

class SinglePhotoScreen extends ConsumerStatefulWidget {
  final Photo photo;
  const SinglePhotoScreen({super.key, required this.photo});
  @override
  SinglePhotoScreenState createState() => SinglePhotoScreenState();
}

class SinglePhotoScreenState extends ConsumerState<SinglePhotoScreen> {
  late Photo photo;

  bool isLoading = false;
  bool isFavorite = false;
  final LocalStorage sharedPrefs = LocalStorage();
  //late AppLocalizations l10n;
  @override
  void initState() {
    photo = widget.photo;
    //l10n = AppLocalizations.of(navigatorKey.currentContext!)!;
    loadSharedPrefs();
    checkFavorite();
    super.initState();
  }

  Future<void> loadSharedPrefs() async {
    await sharedPrefs.init();
  }

  void checkFavorite() {
    Favorite favorite = Favorite.fromPhoto(photo);
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

  void toggleFavorite() async {
    Favorite favorite = Favorite.fromPhoto(photo);

    // SAVE TO OUR LOCAL STORAGE
    Map<String, dynamic> favoriteJson = favorite.toJson();
    final String favoriteEncode = jsonEncode(favoriteJson);

    //final LocalStorage sharedPrefs = LocalStorage();
    //await sharedPrefs.init();
    List<String> listaFavoritos = sharedPrefs.favoritesPhotos;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (!listaFavoritos.contains(favoriteEncode)) {
      listaFavoritos.add(favoriteEncode);
      sharedPrefs.favoritesPhotos = listaFavoritos;

      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(l10n.singleFavoriteAdd)),
      );
    } else {
      listaFavoritos.remove(favoriteEncode);
      sharedPrefs.favoritesPhotos = listaFavoritos;
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(l10n.singleFavoriteDeleted)),
      );
    }
    checkFavorite();
  }

  /* refreshUrlImage() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    Photo updatePhoto;
    final querySent = QuerySent(query: 'test', page: 1, photo: photo);
    try {
      final List<Photo> listPhotos =
          await RequestApi(querySent: querySent).searchPhotos;
      if (listPhotos.isNotEmpty) {
        updatePhoto = listPhotos.first;
        print(listPhotos.length);
        print(updatePhoto.linkDownload ?? updatePhoto.url);
        print(widget.photo == updatePhoto);
        //favoriteImage();
        setState(() {
          //photo = updatePhoto;
          photo.linkDownload = updatePhoto.linkDownload ?? updatePhoto.url;
        });
        //favoriteImage();
      } else {
        print('LISTA VACIA');
      }
    } catch (e) {
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(l10n.searchHomeError)),
      );
      return;
    }
  } */

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
        .catchError((onError) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      return globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(l10n.singleGetError)),
      );
    }).whenComplete(() {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    //l10n = AppLocalizations.of(navigatorKey.currentContext!)!;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    //
    // Photo photo = widget.photo;
    //
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              photo.title ?? l10n.singleNoTitle,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            actions: const [
              /* IconButton(
                onPressed: refreshUrlImage,
                icon: const Icon(Icons.sync),
              ), */
              PopMenu(),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowInfo(
                  photo: photo,
                  attribute: InfoAttribute.author,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZoomPhotoScreen(photo: photo),
                        ),
                      );
                    },
                    child: CachedImage(
                      photo: photo,
                      fit: BoxFit.contain,
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
                onPressed: toggleFavorite,
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
                //onPressed: downloadImage,
                onPressed: () {
                  FileUtil.download(photo);
                  //FileUtil(photo: photo).download();
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.download),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.small(
                heroTag: null,
                //onPressed: shareImage,
                onPressed: () {
                  FileUtil.shared(photo);
                },
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/favorite.dart';
import '../../../data/models/photo.dart';
import '../../../utils/local_storage.dart';
import '../../states/grid_columns_provider.dart';
import '../../widgets/card_view.dart';
import '../../widgets/grid_images.dart';
import '../../widgets/no_images.dart';
import '../../widgets/pop_menu.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<Photo> photos = [];
  bool isLoading = false;
  bool isViewGrid = true;

  @override
  void initState() {
    loadFavorites();
    super.initState();
  }

  void changeViewMode() {
    setState(() => isViewGrid = !isViewGrid);
  }

  Future<void> loadFavorites() async {
    final LocalStorage sharedPrefs = LocalStorage();
    await sharedPrefs.init();
    List<String> favoritesString = sharedPrefs.favoritesPhotos;
    List<Photo> favoritesPhotos = [];
    for (var fav in favoritesString) {
      favoritesPhotos.add(Favorite.fromJson(jsonDecode(fav)));
    }
    setState(() {
      photos = favoritesPhotos;
    });
  }

  Future<void> deleteAllFavorites() async {
    var confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final AppLocalizations l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.favoritesConfirmDelete),
          content: Text(l10n.favoritesRemoveAll),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.favoritesCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.favoritesOk),
            ),
          ],
        );
      },
    );
    if (confirmDelete == true) {
      final LocalStorage sharedPrefs = LocalStorage();
      await sharedPrefs.init();
      sharedPrefs.favoritesPhotos = [];
      loadFavorites();
    }
  }

  void changeCrossAxisCount() {
    ref.read(gridColumnsProvider.notifier).change();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favoritesAppBar),
        actions: [
          if (isViewGrid)
            IconButton(
              onPressed: changeCrossAxisCount,
              icon: const Icon(Icons.view_module),
            ),
          IconButton(
            onPressed: changeViewMode,
            icon: const Icon(Icons.view_list),
          ),
          if (photos.isNotEmpty)
            IconButton(
              onPressed: deleteAllFavorites,
              icon: const Icon(Icons.delete),
            ),
          const PopMenu(),
        ],
      ),
      body: photos.isNotEmpty
          ? isViewGrid
              ? GridImages(photos: photos)
              : CardView(photos: photos)
          : NoImages(message: l10n.favoritesNoImages),
    );
  }
}

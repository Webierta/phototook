import 'dart:convert';

import 'package:flutter/material.dart';
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
      //print(fav);
      favoritesPhotos.add(Favorite.fromJson(jsonDecode(fav)));
    }
    setState(() {
      photos = favoritesPhotos;
    });
  }

  Future<void> deleteAllFavorites() async {
    var confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm delete'),
        content: const Text('This will remove all favorites'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
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
          : const NoImages(message: 'There are no favorites'),
    );
  }
}

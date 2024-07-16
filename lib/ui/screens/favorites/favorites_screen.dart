import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/favorite.dart';
import '../../../data/models/photo.dart';
import '../../../utils/local_storage.dart';
import '../../states/grid_columns_provider.dart';
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

  @override
  void initState() {
    loadFavorites();
    super.initState();
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
    final LocalStorage sharedPrefs = LocalStorage();
    await sharedPrefs.init();
    sharedPrefs.favoritesPhotos = [];
    loadFavorites();
  }

  void changeCrossAxisCount() {
    ref.read(gridColumnsProvider.notifier).change();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            onPressed: deleteAllFavorites,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: changeCrossAxisCount,
            icon: const Icon(Icons.grid_view_sharp),
          ),
          const PopMenu(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : photos.isNotEmpty
              ? GridImages(photos: photos)
              : const NoImages(message: 'There are no favorites'),
    );
  }
}

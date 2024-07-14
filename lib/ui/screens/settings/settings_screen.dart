import 'dart:io';
import 'dart:math';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/models/settings.dart';
import '../../../utils/globals.dart' as globals;
import '../../../utils/local_storage.dart';
import '../../states/settings_provider.dart';
import '../../styles/styles_app.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  final LocalStorage sharedPrefs = LocalStorage();
  //bool isDarkTheme = false;
  //int albumColumns = 3;
  int sizeCacheImages = 0;
  int sizeCacheShared = 0;

  @override
  void initState() {
    loadSharedPrefs();
    getSizeCache();
    super.initState();
  }

  Future<void> getSizeCache() async {
    final cacheDir = await getApplicationCacheDirectory();
    if (cacheDir.existsSync()) {
      for (var file in cacheDir.listSync()) {
        if (file.path.endsWith('.hive') || file.path.endsWith('.lock')) {
          setState(() {
            sizeCacheImages += File(file.path).lengthSync();
          });
        } else {
          setState(() {
            sizeCacheShared += File(file.path).lengthSync();
          });
        }
      }
    } else {
      setState(() {
        sizeCacheImages = 0;
        sizeCacheShared = 0;
      });
    }
  }

  String formatBytes({required int bytes, int decimals = 0}) {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    if (bytes == 0) return '0 ${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Future<void> loadSharedPrefs() async {
    await sharedPrefs.init();
    /* setState(() {
      isDarkTheme = sharedPrefs.isDarkTheme;
      albumColumns = sharedPrefs.albumColumns;
    }); */
  }

  @override
  Widget build(BuildContext context) {
    //bool isDarkTheme = sharedPrefs.isDarkTheme;
    //int albumColumns = sharedPrefs.albumColumns;

    var settings = ref.watch(settingsProvider);
    bool isDarkTheme = settings.isDarkTheme ?? sharedPrefs.isDarkTheme;
    int albumColumns = settings.albumColumns ?? sharedPrefs.albumColumns;

    return Container(
      decoration: BoxDecoration(
        gradient: StylesApp.gradient(Theme.of(context).colorScheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            /* IconButton(
              onPressed: () {
                ref.read(settingsProvider.notifier).setSettings(Settings(
                    isDarkTheme: isDarkTheme, albumColumns: albumColumns));
                sharedPrefs.isDarkTheme = isDarkTheme;
                sharedPrefs.albumColumns = albumColumns;
              },
              icon: const CircleAvatar(child: Icon(Icons.save)),
            ) */
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: OutlinedButton.icon(
                onPressed: () {
                  sharedPrefs.isDarkTheme = isDarkTheme;
                  sharedPrefs.albumColumns = albumColumns;
                  globals.scaffoldMessengerKey.currentState!.showSnackBar(
                    const SnackBar(content: Text('Preferences saved')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ListTile(
                title: Text('Language'),
                trailing: CircleAvatar(child: Text('EN')),
              ),
              const Divider(height: 24),
              SwitchListTile(
                title: const Text('Theme'),
                secondary: CircleAvatar(
                  child: Icon(
                    isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                  ),
                ),
                value: isDarkTheme,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).setSettings(Settings(
                        isDarkTheme: val,
                        albumColumns: albumColumns,
                      ));
                  /* setState(() {
                    isDarkTheme = val;
                  }); */
                },
              ),
              const Divider(height: 24),
              ListTile(
                title: const Text('Columns on results page'),
                subtitle: Slider(
                  value: albumColumns.toDouble(),
                  min: 1,
                  max: 6,
                  divisions: 5,
                  label: '$albumColumns',
                  onChanged: (double value) {
                    /*  setState(() {
                      albumColumns = value.round();
                    }); */
                    ref.read(settingsProvider.notifier).setSettings(Settings(
                        isDarkTheme: isDarkTheme, albumColumns: value.toInt()));
                  },
                ),
                trailing: CircleAvatar(
                  child: Text('$albumColumns'),
                ),
              ),
              const Divider(height: 24),
              ListTile(
                title: const Text('Delete cache of displayed images'),
                subtitle: Text('Size: ${formatBytes(bytes: sizeCacheImages)}'),
                trailing: OutlinedButton(
                  onPressed: () async {
                    await FastCachedImageConfig.clearAllCachedImages();
                    setState(() => sizeCacheImages = 0);
                    globals.scaffoldMessengerKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text('Cache of displayed images deleted'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 2, color: Colors.black45),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Icon(Icons.clear),
                ),
              ),
              const Divider(height: 24),
              ListTile(
                title: const Text('Delete cache of shared images'),
                subtitle: Text('Size: ${formatBytes(bytes: sizeCacheShared)}'),
                trailing: OutlinedButton(
                  onPressed: () async {
                    final cacheDir = await getApplicationCacheDirectory();
                    if (cacheDir.existsSync()) {
                      //cacheDir.deleteSync(recursive: true);
                      for (var file in cacheDir.listSync()) {
                        if (!file.path.endsWith('.hive') &&
                            !file.path.endsWith('.lock')) {
                          file.delete();
                        }
                      }
                      setState(() => sizeCacheShared = 0);
                    }
                    //cacheDir.create();
                    globals.scaffoldMessengerKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text('Cache of shared images deleted'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 2, color: Colors.black45),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Icon(Icons.clear),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

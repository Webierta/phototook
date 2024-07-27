import 'dart:io';
import 'dart:math';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/models/query_sent.dart';
import '../../../data/models/settings.dart';
import '../../../utils/globals.dart' as globals;
import '../../../utils/local_storage.dart';
import '../../../utils/locales_app.dart';
import '../../states/grid_columns_provider.dart';
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
  late String lang;
  late bool isDarkTheme;
  late int albumColumns;
  late SearchLevel searchLevel;

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
    /* lang = sharedPrefs.lang;
    isDarkTheme = sharedPrefs.isDarkTheme;
    albumColumns = sharedPrefs.albumColumns; */

    /* setState(() {
      isDarkTheme = sharedPrefs.isDarkTheme;
      albumColumns = sharedPrefs.albumColumns;
    }); */
  }

  @override
  Widget build(BuildContext context) {
    //bool isDarkTheme = sharedPrefs.isDarkTheme;
    //int albumColumns = sharedPrefs.albumColumns;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    //var settings = ref.watch(settingsProvider);
    /* String lang = settings.idioma ?? sharedPrefs.lang;
    bool isDarkTheme = settings.isDarkTheme ?? sharedPrefs.isDarkTheme;
    int albumColumns = settings.albumColumns ?? sharedPrefs.albumColumns; */
    /* String lang = sharedPrefs.lang;
    bool isDarkTheme = sharedPrefs.isDarkTheme;
    int albumColumns = sharedPrefs.albumColumns; */
    /* ref.read(settingsProvider.notifier).setSettings(Settings(
          idioma: lang,
          isDarkTheme: isDarkTheme,
          albumColumns: albumColumns,
        )); */
    lang = ref.watch(settingsProvider).idioma;
    isDarkTheme = ref.watch(settingsProvider).isDarkTheme;
    albumColumns = ref.watch(settingsProvider).albumColumns;

    searchLevel = ref.watch(settingsProvider).searchLevel;

    return Container(
      decoration: BoxDecoration(
        gradient: StylesApp.gradient(Theme.of(context).colorScheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.settingsAppBar),
          // Text(AppLocalizations.of(context)!.helloWorld),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.settingsLanguage),
                      leading: const Icon(Icons.translate),
                      //trailing: CircleAvatar(child: Text('EN')),
                      trailing: DropdownMenu<String>(
                        initialSelection: lang,
                        //textStyle: TextStyle(),
                        onSelected: (String? value) {
                          //ref.read(settingsProvider.notifier).setLang(value!);
                          /* ref
                              .read(settingsProvider.notifier)
                              .setSettings(Settings(
                                idioma: value!,
                                isDarkTheme: isDarkTheme,
                                albumColumns: albumColumns,
                              )); */
                          ref.read(settingsProvider.notifier).setLang(value!);
                        },
                        dropdownMenuEntries:
                            LocalesApp.langCodes.map((String code) {
                          return DropdownMenuEntry<String>(
                            value: code,
                            label: LocalesApp().langName(code),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(height: 24),
                    SwitchListTile(
                      title: Text(l10n.settingsThemeLight),
                      secondary: const Icon(Icons.brightness_6),
                      thumbIcon: WidgetStateProperty.all(
                        Icon(isDarkTheme ? Icons.dark_mode : Icons.light_mode),
                      ),
                      value: isDarkTheme,
                      onChanged: (val) {
                        /* ref
                            .read(settingsProvider.notifier)
                            .setSettings(Settings(
                              idioma: lang,
                              isDarkTheme: val,
                              albumColumns: albumColumns,
                            )); */
                        ref.read(settingsProvider.notifier).setTheme(val);
                        /* setState(() {
                          isDarkTheme = val;
                        }); */
                      },
                    ),
                    const Divider(height: 24),
                    ListTile(
                      title: Text(l10n.settingsNumberColumns),
                      leading: const Icon(Icons.view_module),
                      titleAlignment: ListTileTitleAlignment.top,
                      //dense: true,
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
                          ref
                              .read(gridColumnsProvider.notifier)
                              .fit(value.toInt());
                          /* ref.read(settingsProvider.notifier).setSettings(
                              Settings(
                                  idioma: lang,
                                  isDarkTheme: isDarkTheme,
                                  albumColumns: value.toInt())); */
                          ref
                              .read(settingsProvider.notifier)
                              .setAlbumColumns(value.toInt());
                          /* ref
                              .read(settingsProvider.notifier)
                              .setAlbumColumns(value.toInt()); */
                        },
                      ),
                      trailing: CircleAvatar(
                        child: Text('$albumColumns'),
                      ),
                    ),
                    const Divider(height: 24),
                    ListTile(
                      title: Row(
                        children: [
                          const Text('Nivel de profundidad de la búsqueda'),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(l10n.settingsLevel),
                                      content: Column(
                                        children: [
                                          Text(l10n.settingsLevelInfo1),
                                          const SizedBox(height: 12),
                                          Text(l10n.settingsLevelInfo2),
                                          const SizedBox(height: 12),
                                          Text(l10n.settingsLevelInfo3),
                                          const SizedBox(height: 12),
                                          Text(l10n.settingsLevelInfo3),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child:
                                              Text(l10n.settingsLevelInfoClose),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.info),
                          )
                        ],
                      ),

                      leading: const Icon(Icons.image_search),
                      titleAlignment: ListTileTitleAlignment.top,
                      //dense: true,
                      subtitle: Slider(
                        value: searchLevel.valor.toDouble(),
                        min: 0,
                        max: 2,
                        divisions: 2,
                        label: searchLevel.name.toUpperCase(),
                        onChanged: (double value) {
                          ref.read(settingsProvider.notifier).setSearchLevel(
                              SearchLevel.values.firstWhere(
                                  (level) => level.valor == value.toInt()));
                        },
                      ),
                      trailing: Text(searchLevel.name.toUpperCase()),
                    ),
                    const Divider(height: 24),
                    ListTile(
                      title: Text(l10n.settingsRemoveCache),
                      leading: const Icon(Icons.collections),
                      titleAlignment: ListTileTitleAlignment.top,
                      //dense: true,
                      subtitle:
                          Text('Size: ${formatBytes(bytes: sizeCacheImages)}'),
                      trailing: CircleAvatar(
                        child: IconButton(
                          onPressed: () async {
                            await FastCachedImageConfig.clearAllCachedImages();
                            setState(() => sizeCacheImages = 0);
                            globals.scaffoldMessengerKey.currentState!
                                .showSnackBar(
                              SnackBar(
                                content: Text(l10n.settingsCacheRemoved),
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever),
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    ListTile(
                      title: const Text('Delete cache of shared images'),
                      leading: const Icon(Icons.collections),
                      titleAlignment: ListTileTitleAlignment.top,
                      subtitle:
                          Text('Size: ${formatBytes(bytes: sizeCacheShared)}'),
                      trailing: CircleAvatar(
                        child: IconButton(
                          onPressed: () async {
                            final cacheDir =
                                await getApplicationCacheDirectory();
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
                            globals.scaffoldMessengerKey.currentState!
                                .showSnackBar(
                              const SnackBar(
                                content: Text('Cache of shared images deleted'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_forever),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          sharedPrefs.lang = lang;
                          sharedPrefs.isDarkTheme = isDarkTheme;
                          sharedPrefs.albumColumns = albumColumns;
                          sharedPrefs.searchLevel = searchLevel.name;
                          ref
                              .watch(settingsProvider.notifier)
                              .setSettings(Settings(
                                idioma: lang,
                                isDarkTheme: isDarkTheme,
                                albumColumns: albumColumns,
                                searchLevel: searchLevel,
                              ));
                          globals.scaffoldMessengerKey.currentState!
                              .showSnackBar(
                            SnackBar(content: Text(l10n.settingsSavedSettings)),
                          );
                        },
                        child: Text(
                          l10n.settingsSave,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

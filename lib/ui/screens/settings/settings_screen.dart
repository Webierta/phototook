import 'dart:io';
import 'dart:math';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/models/query_sent.dart';
import '../../../data/models/settings.dart';
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

  int sizeCacheImages = 0;
  //int sizeCacheShared = 0;
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
        }
        /* else {
          setState(() {
            sizeCacheShared += File(file.path).lengthSync();
          });
        } */
      }
    } else {
      setState(() {
        sizeCacheImages = 0;
        //sizeCacheShared = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    ScaffoldMessengerState sms = ScaffoldMessenger.of(context);

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
        appBar: AppBar(title: Text(l10n.settingsAppBar)),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 2,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(l10n.settingsLanguage),
                        leading: const Icon(Icons.translate),
                        trailing: DropdownMenu<String>(
                          initialSelection: lang,
                          onSelected: (String? value) {
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
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(l10n.settingsThemeLight),
                        secondary: const Icon(Icons.brightness_6),
                        thumbIcon: WidgetStateProperty.all(
                          Icon(
                            isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                          ),
                        ),
                        value: isDarkTheme,
                        onChanged: (val) {
                          ref.read(settingsProvider.notifier).setTheme(val);
                        },
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: Text(l10n.settingsNumberColumns),
                        leading: const Icon(Icons.grid_on),
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        //dense: true,
                        subtitle: Slider(
                          value: albumColumns.toDouble(),
                          min: 1,
                          max: 6,
                          divisions: 5,
                          label: '$albumColumns',
                          onChanged: (double value) {
                            ref
                                .read(gridColumnsProvider.notifier)
                                .fit(value.toInt());
                            ref
                                .read(settingsProvider.notifier)
                                .setAlbumColumns(value.toInt());
                          },
                        ),
                        trailing: CircleAvatar(
                          child: Text('$albumColumns'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: l10n.settingsLevel),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            const SearchLevelInfo(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.info, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: const Icon(Icons.manage_search),
                        titleAlignment: ListTileTitleAlignment.titleHeight,
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
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              searchLevel.name.substring(0, 3).toUpperCase(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: Text(l10n.settingsRemoveCache),
                        leading: const Icon(Icons.collections),
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        //dense: true,
                        subtitle: Text(
                            'Size: ${formatBytes(bytes: sizeCacheImages)}'),
                        trailing: CircleAvatar(
                          child: IconButton(
                            onPressed: () async {
                              await FastCachedImageConfig
                                  .clearAllCachedImages();
                              setState(() => sizeCacheImages = 0);
                              sms.hideCurrentSnackBar();
                              sms.showSnackBar(SnackBar(
                                content: Text(l10n.settingsCacheRemoved),
                              ));
                            },
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ),
                      ),
                      /* const Divider(height: 24),
                      ListTile(
                        title: const Text('Delete cache of shared images'),
                        leading: const Icon(Icons.collections),
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        subtitle: Text(
                            'Size: ${formatBytes(bytes: sizeCacheShared)}'),
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
                              scaffoldMessengerKey.currentState!.showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Cache of shared images deleted'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ),
                      ), */
                    ],
                  ),
                ),
              ),
              /*  Container(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                width: MediaQuery.of(context).size.width, */
              Padding(
                padding: const EdgeInsets.all(10),
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
                            //showSnackBar(l10n.settingsSavedSettings);
                            /* scaffoldMessengerKey.currentState!.showSnackBar(
                              SnackBar(
                                content: Text(l10n.settingsSavedSettings),
                              ),
                            ); */
                            sms.hideCurrentSnackBar();
                            sms.showSnackBar(SnackBar(
                              content: Text(l10n.settingsSavedSettings),
                            ));
                          },
                          child: Text(
                            l10n.settingsSave.toUpperCase(),
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
      ),
    );
  }
}

class SearchLevelInfo extends StatelessWidget {
  const SearchLevelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: StylesApp.gradient(Theme.of(context).colorScheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Info'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                l10n.settingsLevel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              Text(l10n.settingsLevelInfo1),
              const SizedBox(height: 14),
              Text(
                l10n.settingsLevelLow,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(l10n.settingsLevelInfo2),
              const SizedBox(height: 14),
              Text(
                l10n.settingsLevelMax,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(l10n.settingsLevelInfo3),
              const SizedBox(height: 14),
              Text(
                l10n.settingsLevelMedium,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(l10n.settingsLevelInfo4),
            ],
          ),
        ),
      ),
    );
  }
}

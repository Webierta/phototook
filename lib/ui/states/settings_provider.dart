import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/settings.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

  void setSettings(Settings settings) {
    state = settings;
  }

  void setLang(String idioma) {
    //state = Settings(idioma: idioma);
    final newState = state.copy(idioma: idioma);
    state = newState;
  }

  void setTheme(bool isDarkTheme) {
    //state.isDarkTheme = isDarkTheme;
    //state = Settings(isDarkTheme: isDarkTheme);
    //state.isDarkTheme = isDarkTheme;
    final newState = state.copy(isDarkTheme: isDarkTheme);
    state = newState;
  }

  void setAlbumColumns(int columns) {
    //state = Settings(albumColumns: columns);
    //state.albumColumns = columns;
    int albumColumns = columns;
    if (columns > 6) {
      albumColumns = 1;
    }
    final newState = state.copy(albumColumns: albumColumns);
    state = newState;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);

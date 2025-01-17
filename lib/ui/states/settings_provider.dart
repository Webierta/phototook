import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/query_sent.dart';
import '../../data/models/settings.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

  void setSettings(Settings settings) {
    state = settings;
  }

  void setLang(String idioma) {
    final newState = state.copy(idioma: idioma);
    state = newState;
  }

  void setTheme(bool isDarkTheme) {
    final newState = state.copy(isDarkTheme: isDarkTheme);
    state = newState;
  }

  void setAlbumColumns(int columns) {
    int albumColumns = columns;
    if (columns > 6) {
      albumColumns = 1;
    }
    final newState = state.copy(albumColumns: albumColumns);
    state = newState;
  }

  void setSearchLevel(SearchLevel level) {
    final newState = state.copy(searchLevel: level);
    state = newState;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);

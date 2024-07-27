import 'query_sent.dart';

class Settings {
  String idioma;
  bool isDarkTheme;
  int albumColumns;
  SearchLevel searchLevel;

  Settings({
    this.idioma = 'en',
    this.isDarkTheme = true,
    this.albumColumns = 3,
    this.searchLevel = SearchLevel.medium,
  });

  Settings copy({
    idioma,
    isDarkTheme,
    albumColumns,
    searchLevel,
  }) =>
      Settings(
        idioma: idioma ?? this.idioma,
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        albumColumns: albumColumns ?? this.albumColumns,
        searchLevel: searchLevel ?? this.searchLevel,
      );
}

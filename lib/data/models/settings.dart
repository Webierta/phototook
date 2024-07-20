class Settings {
  String idioma;
  bool isDarkTheme;
  int albumColumns;

  Settings({
    this.idioma = 'en',
    this.isDarkTheme = true,
    this.albumColumns = 3,
  });

  Settings copy({
    idioma,
    isDarkTheme,
    albumColumns,
  }) =>
      Settings(
        idioma: idioma ?? this.idioma,
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        albumColumns: albumColumns ?? this.albumColumns,
      );
}

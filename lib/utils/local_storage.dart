import 'package:shared_preferences/shared_preferences.dart';

//const String keyLang = 'keyLang';
//const String keyDarkTheme = 'keyDarkTheme';
//const String keyAlbumColumns = 'keyAlbumColumns';
//const String keyFavoritesPhotos = 'keyFavoritesPhotos';

class LocalStorage {
  static SharedPreferences? _sharedPrefs;
  static const String _lang = 'keyLang';
  static const String _isDarkTheme = 'keyDarkTheme';
  static const String _albumColumns = 'keyAlbumColumns';
  static const String _favoritesPhotos = 'keyFavoritesPhotos';

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get lang => _sharedPrefs?.getString(_lang) ?? '';
  set lang(String value) => _sharedPrefs?.setString(_lang, value);

  bool get isDarkTheme => _sharedPrefs?.getBool(_isDarkTheme) ?? true;
  set isDarkTheme(bool value) => _sharedPrefs?.setBool(_isDarkTheme, value);

  int get albumColumns => _sharedPrefs?.getInt(_albumColumns) ?? 3;
  set albumColumns(int value) => _sharedPrefs?.setInt(_albumColumns, value);

  List<String> get favoritesPhotos =>
      _sharedPrefs?.getStringList(_favoritesPhotos) ?? [];

  set favoritesPhotos(List<String> value) {
    //favoritesPhotos.add(value);
    _sharedPrefs?.setStringList(_favoritesPhotos, value);
  }
}

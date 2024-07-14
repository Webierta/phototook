import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'data/models/settings.dart';
import 'ui/screens/search_home/search_home.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/states/settings_provider.dart';
import 'ui/styles/theme_app.dart';
import 'utils/consts.dart';
import 'utils/globals.dart' as globals;
import 'utils/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String cacheLocation = (await getApplicationCacheDirectory()).path;
  await FastCachedImageConfig.init(
    subDir: cacheLocation,
    clearCacheAfter: const Duration(days: 15),
  );
  await dotenv.load(fileName: 'assets/.env');
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});
  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    loadSharedPref();
    super.initState();
  }

  loadSharedPref() async {
    final LocalStorage sharedPrefs = LocalStorage();
    await sharedPrefs.init();
    ref.read(settingsProvider.notifier).setSettings(Settings(
          isDarkTheme: sharedPrefs.isDarkTheme,
          albumColumns: sharedPrefs.albumColumns,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var settings = ref.watch(settingsProvider);
    // String? applicationId = dotenv.maybeGet('ApplicationID', fallback: null);
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: globals.scaffoldMessengerKey,
      themeMode: settings.isDarkTheme! ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeApp.lightThemeData,
      darkTheme: ThemeApp.darkThemeData,
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (context) => const SplashScreen(),
        '/home': (BuildContext context) => const SearchHomeScreen(),
        //'/settings': (BuildContext context) => const SettingScreen(),
      },
    );
  }
}

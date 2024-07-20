import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/about/about_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/settings/settings_screen.dart';

enum OptionScreen {
  /* favorites('Favorites', Icons.favorite, FavoritesScreen()),
  settings('Settings', Icons.settings, SettingsScreen()),
  about('About', Icons.code, AboutScreen()); */

  favorites(Icons.favorite, FavoritesScreen()),
  settings(Icons.settings, SettingsScreen()),
  about(Icons.code, AboutScreen());

  //final String label;
  final IconData icon;
  final Widget screen;
  const OptionScreen(
      //this.label,
      this.icon,
      this.screen);
}

class PopMenu extends StatefulWidget {
  const PopMenu({super.key});
  @override
  State<PopMenu> createState() => _PopMenuState();
}

class _PopMenuState extends State<PopMenu> {
  void _selectOption(OptionScreen option) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => option.screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<OptionScreen>(
      onSelected: _selectOption,
      itemBuilder: (BuildContext context) {
        return OptionScreen.values.map((choice) {
          return PopupMenuItem<OptionScreen>(
            value: choice,
            child: ListTile(
              leading: Icon(choice.icon),
              //title: Text(choice.label),
              title: Text(l10n.popMenuOptionScreen(choice.name)),
            ),
          );
        }).toList();
      },
    );
  }
}

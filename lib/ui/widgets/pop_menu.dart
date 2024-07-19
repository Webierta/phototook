import 'package:flutter/material.dart';

import '../screens/about/about_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/settings/settings_screen.dart';

enum OptionScreen {
  favorites('Favorites', Icons.favorite, FavoritesScreen()),
  settings('Settings', Icons.settings, SettingsScreen()),
  about('About', Icons.code, AboutScreen());

  final String label;
  final IconData icon;
  final Widget screen;
  const OptionScreen(this.label, this.icon, this.screen);
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
    return PopupMenuButton<OptionScreen>(
      onSelected: _selectOption,
      itemBuilder: (BuildContext context) {
        return OptionScreen.values.map((choice) {
          return PopupMenuItem<OptionScreen>(
            value: choice,
            child: ListTile(
              leading: Icon(choice.icon),
              title: Text(choice.label),
            ),
          );
        }).toList();
      },
    );
  }
}

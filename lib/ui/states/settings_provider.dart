import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/settings.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(const Settings());

  void setSettings(Settings settings) {
    state = settings;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);

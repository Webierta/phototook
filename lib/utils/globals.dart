import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final AppLocalizations l10n =
    AppLocalizations.of(navigatorKey.currentContext!)!;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
/* globals.scaffoldMessengerKey.currentState!.showSnackBar(
  SnackBar(content: Text(l10n.singleFavoriteDeleted)),
); */

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//final AppLocalizations l10n = AppLocalizations.of(context)!;
final AppLocalizations l10n =
    AppLocalizations.of(navigatorKey.currentContext!)!;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/consts.dart';
import '../../styles/styles_app.dart';
import 'btc_wallet_address.dart';
import 'markdown_text.dart';

const String urlPayPal =
    'https://www.paypal.com/donate?hosted_button_id=986PSAHLH6N4L';
const String urlGitHub = 'https://github.com/Webierta/phototook';
const String urlGitHubIssues = 'https://github.com/Webierta/phototook/issues';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final idioma = ref.watch(settingsProvider).idioma;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    Future<void> launchWeb(String url) async {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch $url'),
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: StylesApp.gradient(Theme.of(context).colorScheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('About'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    appName,
                    style: TextStyle(fontFamily: fontLogo, fontSize: 32),
                  ),
                  MarkdownText(data: l10n.aboutSubtitle),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.4,
                  ),
                  MarkdownText(data: l10n.aboutIntro1),
                  MarkdownText(data: l10n.aboutIntro2),
                  //MarkdownText(data: l10n.aboutIntro3),
                  MarkdownText(data: l10n.aboutIntro4),
                  Center(
                    child: Icon(
                      Icons.contact_support,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  MarkdownText(data: l10n.aboutIntro3),
                  MarkdownText(data: l10n.aboutIntro5),
                  MarkdownText(data: l10n.aboutIntro6),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.4,
                  ),
                  MarkdownText(data: l10n.aboutAuthor),
                  const MarkdownText(data: authorBlock),
                  MarkdownText(data: l10n.aboutLicense),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.4,
                  ),
                  MarkdownText(data: l10n.aboutSupport),
                  MarkdownText(data: l10n.aboutSupport1),
                  MarkdownText(data: l10n.aboutSupport2(urlGitHubIssues)),
                  MarkdownText(data: l10n.aboutSupport3),
                  MarkdownText(data: l10n.aboutPaypal),
                  Center(
                    child: GestureDetector(
                      onTap: () => launchWeb(urlPayPal),
                      child: Image.asset('assets/images/paypal.png'),
                    ),
                  ),
                  MarkdownText(data: l10n.aboutBTC1),
                  Center(child: Image.asset('assets/images/Bitcoin_QR.png')),
                  MarkdownText(data: l10n.aboutBTC2),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: BtcWalletAddress(),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.4,
                  ),
                  MarkdownText(data: l10n.aboutWarranty),
                  MarkdownText(data: l10n.aboutWarranty2),
                  MarkdownText(data: l10n.aboutWarranty3),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.4,
                  ),
                  const MarkdownText(data: attributions),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String authorBlock = """
> Jesús Cuerda (Webierta)
> PhotoTook $version
> Copyleft 2024. Hosted on [Github]($urlGitHub)
> All Wrongs Reserved. Licencia GPLv3
""";

const String attributions = """
## Attributions

### Image sources:

* [Unsplash](https://unsplash.com/).

* [Pexels](https://www.pexels.com).

* [Flickr](https://www.flickr.com).

* [Pixabay](https://pixabay.com/).

* [Openverse](https://openverse.org).

### Images:

* Home screen image of [Lisa Fotios](https://www.pexels.com/es-es/foto/persona-con-foto-de-un-solo-arbol-durante-el-dia-1252983/) on Pexels. Free for use under the [Pexels License](https://www.pexels.com/license/).

* GIF of [David Montero](https://pixabay.com/es/users/editiox-6398285/?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6613) on [Pixabay](https://pixabay.com/es//?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6613). Free for use under the Pixabay [Content License](https://pixabay.com/service/license-summary/).

* GIF of [David Montero](https://pixabay.com/es/users/editiox-6398285/?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6592) on [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=animation&utm_content=6592). Free for use under the Pixabay [Content License](https://pixabay.com/service/license-summary/).

### Fonts:

* Victor Mono. Copyright 2023 [The Victor Mono Project Authors](https://github.com/rubjo/victor-mono-font). Licensed under the SIL Open Font License, Version 1.1.

* Major Mono Display. Copyright 2018 [The Major Mono Project Authors](https://github.com/googlefonts/majormono). Licensed under the SIL Open Font License, Version 1.1.

""";

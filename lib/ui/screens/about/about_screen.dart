import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/settings_provider.dart';
import '../../styles/styles_app.dart';
import 'btc_wallet_address.dart';
import 'markdown_locales.dart';
import 'markdown_text.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idioma = ref.watch(settingsProvider).idioma;

    String data1 = switch (idioma) {
      'en' => MarkdownLocales.en1,
      'es' => MarkdownLocales.es1,
      _ => MarkdownLocales.en1,
    };

    String data2 = switch (idioma) {
      'en' => MarkdownLocales.en2,
      'es' => MarkdownLocales.es2,
      _ => MarkdownLocales.en2,
    };

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
                children: [
                  MarkdownText(data: data1),
                  const BtcWalletAddress(),
                  MarkdownText(data: data2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
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
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MarkdownText(data: MarkdownAbout.en1),
                  BtcWalletAddress(),
                  MarkdownText(data: MarkdownAbout.en2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} */

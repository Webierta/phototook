import 'package:flutter/material.dart';

import '../../styles/styles_app.dart';
import 'btc_wallet_address.dart';
import 'markdown_about.dart';
import 'markdown_text.dart';

class AboutScreen extends StatefulWidget {
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
}

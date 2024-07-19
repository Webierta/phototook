import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../styles/markdown_style.dart';

class MarkdownText extends StatelessWidget {
  final String data;
  const MarkdownText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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

    return Markdown(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 20),
      data: data,
      //styleSheet: MarkdownStyle.buildMarkdownStyleSheet(),
      styleSheet:
          MarkdownStyle(theme: Theme.of(context)).buildMarkdownStyleSheet,
      onTapLink: (text, url, title) {
        launchWeb(url!);
      },
    );
  }
}

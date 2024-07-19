import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:phototook/utils/consts.dart';

class MarkdownStyle {
  //final BuildContext context;
  final ThemeData theme;

  MarkdownStyle({required this.theme});

  //static
  MarkdownStyleSheet get buildMarkdownStyleSheet {
    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      h1: const TextStyle(
        //color: Color(0xFFB0BEC5),
        fontSize: 32,
        fontWeight: FontWeight.w100,
        fontFamily: fontLogo,
      ),
      h2: const TextStyle(
        //color: Color(0xFFB0BEC5),
        fontSize: 22,
      ),
      h3: const TextStyle(
        //color: Color(0xFFB0BEC5),
        fontSize: 18,
      ),
      h4: theme.textTheme.labelMedium,
      p: const TextStyle(fontSize: 16),
      /* blockquoteDecoration: const BoxDecoration(
        color: Colors.blueGrey,        
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ), */
      //blockquoteDecoration: const BoxDecoration(color: null),

      blockSpacing: 20,
      blockquotePadding: const EdgeInsets.all(14),
      //blockquote: const TextStyle(color: Colors.red),
      blockquoteDecoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border.all(
          width: 0.8,
          color: Colors.white30,
        ),
        //borderRadius: BorderRadius.circular(12),
      ),
      //textAlign: WrapAlignment.center,
      h6Align: WrapAlignment.center,
    );
  }
}

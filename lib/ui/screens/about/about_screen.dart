import 'package:flutter/material.dart';

import '../../../utils/consts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appName,
          style: TextStyle(fontFamily: fontLogo),
        ),
      ),
      body: const Center(
        child: Text('About'),
      ),
    );
  }
}
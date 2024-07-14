import 'package:flutter/material.dart';

import '../../../utils/consts.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
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
        child: Text('Info'),
      ),
    );
  }
}

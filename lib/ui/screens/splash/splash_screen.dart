import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/consts.dart';
import '../../styles/styles_app.dart';
import '../../styles/theme_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer1;
  late Timer timer2;
  var child = Image.asset(
    'assets/images/camera.gif',
    key: const ValueKey<int>(1),
  );
  bool logoVisible = false;

  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  void dispose() {
    timer1.cancel();
    timer2.cancel();
    super.dispose();
  }

  timer() {
    timer1 = Timer(const Duration(seconds: 1), () {
      setState(() {
        logoVisible = true;
        child = Image.asset(
          'assets/images/photos.gif',
          key: const ValueKey<int>(2),
        );
      });
      timer2 = Timer(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: StylesApp.gradient(ThemeApp.darkColorScheme),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          RotationTransition(turns: animation, child: child),
                  child: child,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: logoVisible
                      ? const FittedBox(
                          key: ValueKey<int>(5),
                          child: Text(
                            appName,
                            style: TextStyle(
                              fontFamily: fontLogo,
                              fontSize: 40,
                              color: Colors.white,
                            ),
                            key: ValueKey<int>(3),
                          ),
                        )
                      : const SizedBox(key: ValueKey<int>(4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

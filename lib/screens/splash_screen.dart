import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/screens/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigation(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      body: Center(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Lottie.asset(
          //   'lib/assets/107575-ai-music-animation.json',
          // ),
          Image.asset(
            'lib/assets/7B3B28CE-A9CA-44B5-8B3E-69108D099D6B.PNG',
          )
        ],
      )),
    );
  }
}

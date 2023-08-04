import 'package:chat/main.dart';
import 'package:chat/onboarding.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then(
        (value) => Navigator.push(context, MaterialPageRoute(builder: (c) {
              return OnBoardingScreen();
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/chat.png'),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled2/data/trending_data.dart';
import 'package:untitled2/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/originals/8a/81/5a/8a815a9c7a2005302312ece1fd1a8f1a.jpg"),
            fit: BoxFit.cover,
          )
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://github.com/ThomasGrossmann/PreTPI/tree/develop/CryptoFeed/lib/widget/assets/Logo.png")
            )
          )
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, PageRouteBuilder(
        pageBuilder: (c, a1, a2) => TrendingPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 2000)
    ));
  }
}
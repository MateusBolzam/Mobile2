import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../layout/bottombar.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              //builder: (context) => TopBar()
              builder: (context) => const BottomBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black87,
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 11, 123, 227),
                Color.fromARGB(255, 230, 255, 68),
                Color.fromARGB(255, 55, 255, 24)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Lottie.asset("./assets/images/animacao.json")));
  }
}

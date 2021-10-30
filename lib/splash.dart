import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coffee/home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.network(
          'https://i.ibb.co/t8kpHJ0/Blue-Green-Pink-Modern-Mobile-Phone-Logo.png'),
    ));
  }
}

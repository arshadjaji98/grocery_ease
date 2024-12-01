

import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/services/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashService = SplashService();
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isSplash(context);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Splash Screen",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
        ],
      ),
    );
  }
}

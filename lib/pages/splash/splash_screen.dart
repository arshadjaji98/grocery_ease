import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/services/splash_service.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  SplashService splashService = SplashService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration
    );

    // Define a scaling animation
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Start the splash service
    splashService.isSplash(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfdfdfd),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Static Splash Image
          Image.asset('assets/images/splash.jpg'),
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/images/logo.png',
                  height: 250, width: 250),
            ),
          ),

          // Tagline
          Text(
            "Fresh. Fast. Delivered.",
            style: AppWidgets.boldTextFieldStyle(),
          ),

          const CircularProgressIndicator(color: Colors.green),
        ],
      ),
    );
  }
}

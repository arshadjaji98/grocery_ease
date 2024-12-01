import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/admin/admin_home_screen.dart';
import '../pages/super_admin/super_admin_home_screen.dart';
import '../pages/user/bottom_nav_bar.dart';
import '../pages/registration/login.dart';

class SplashService {
  Future<void> isSplash(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        var doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();

        if (doc.exists && doc.data() != null) {
          String? userRole = doc.data()?['user_role'];
          if (userRole == "user") {
            Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav())));
          } else if(userRole == "admin") {
            Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeAdmin())));
          }else if(userRole == "superAdmin"){
            Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SuperAdminHomeScreen())));
          }else{
            Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogIn())));
          }
        } else {
          Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogIn())));
        }
      } catch (e) {
        // Handle Firestore errors
        print("Error: $e");
        Future.delayed(const Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogIn())));
      }
    } else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LogIn()));
      });
    }
  }
}

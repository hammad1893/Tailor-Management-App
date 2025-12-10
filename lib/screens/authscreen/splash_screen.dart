import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_app/screens/authscreen/login_screen.dart';
import 'package:tailor_app/screens/authscreen/signup_screen.dart';
import 'package:tailor_app/screens/homescreen/homepage.dart';
import 'package:tailor_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkuserstatus();
  }

  Future<void> checkuserstatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
      );
      print("User: $user | First time: $isFirstTime");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: Center(
        child: Image.asset(
          "assets/images/appicon.png",
          fit: BoxFit.cover,
          height: size.height * .3,
          width: size.width * .6,
        ),
      ),
    );
  }
}

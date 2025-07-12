import 'dart:async';
import 'package:e_commerce/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/my_text.dart';
import 'login_screend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 3.0).animate(_controller);
    _controller.forward();
    navigate();
  }

  Future<void> navigate() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLogin = pref.getBool("isLogin") ?? false;
    print("this is is login $isLogin");
    Timer(const Duration(seconds: 4), () {
      if(isLogin == true){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }

    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/splash_logo.png',
                width: 800.w,
                height: 500.h,
              ),
            ),
            SizedBox(height: 20.h),
            CustomGradientText(
              text: 'ShopNow',
              fontWeight: FontWeight.bold,
              fontSize: 80.sp,
              width: 900.w,
            ),
          ],
        ),
      ),
    );
  }

}

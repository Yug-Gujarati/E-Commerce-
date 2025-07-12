import 'package:e_commerce/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    bool isValid = true;

    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      emailError = 'Enter a valid email';
      isValid = false;
    } else {
      emailError = null;
    }

    if (password.length < 8) {
      passwordError = 'Password must be at least 8 characters';
      isValid = false;
    } else {
      passwordError = null;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> login(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (validateInputs()) {
      Get.snackbar("Welcome", "Login Successfully");
      pref.setBool("isLogin", true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

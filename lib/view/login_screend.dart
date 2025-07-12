import 'package:e_commerce/utils/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../utils/textField.dart';
import '../view_model/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isPress = false;
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);



    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.w),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 1080.w,
              height: 1920.h,
              child: Column(
                children: [
                  SizedBox(height: 50.h,),
                  Image.asset(
                    'assets/splash_logo.png',
                    width: 500.w,
                    height: 500.h,
                  ),
                  Spacer(),
                  CustomGradientText(
                    text: 'Login',
                    fontWeight: FontWeight.bold,
                    fontSize: 80.sp,
                    width: 900.w,
                  ),
                  SizedBox(height: 50.h),

                  // Email
                  TransparentTextField(
                    controller: loginProvider.emailController,
                    labelText: 'Email',

                  ),
                  if (loginProvider.emailError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        loginProvider.emailError!,
                        style: TextStyle(color: Colors.red, fontSize: 30.sp),
                      ),
                    ),
                  SizedBox(height: 40.h),

                  // Password
                  TransparentTextField(
                    controller: loginProvider.passwordController,
                    labelText: 'Password',
                  ),
                  if (loginProvider.passwordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        loginProvider.passwordError!,
                        style: TextStyle(color: Colors.red, fontSize: 30.sp),
                      ),
                    ),
                  SizedBox(height: 60.h),

                  GestureDetector(
                    onTapCancel: () {
                      setState(() {
                        isPress = false;
                      });
                    },
                    onTapDown: (d) {
                      setState(() {
                        isPress = true;
                      });
                    },
                    onTapUp: (ui) {
                      setState(() {
                        isPress = false;
                      });
                    },
                    onTap: () {
                      if(loginProvider.emailController.text.trim().isEmpty || loginProvider.passwordController.text.trim().isEmpty){
                        Get.snackbar("Error", "Please enter email address and password");
                      }
                      else{
                        loginProvider.login(context);
                      }


                    },
                    child: Opacity(
                      opacity: isPress ? 0.5 : 1,
                      child: Container(
                        width: 800.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFFFF4852),
                            Color(0xFFFDD70E)
                          ]),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: MyText(
                              text: "Login",
                              fontSize: 50.sp,
                              fontWeight: FontWeight.w800,
                              textColor: Colors.white,
                              align: TextAlign.center,
                              width: 450,
                              maxline: 1),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(height: 400.h,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:chat_app/view/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() async {
    await navigate();
    super.onInit();
  }

  Future<void> navigate() async {
    final user = FirebaseAuth.instance.currentUser;

    Future.delayed(Duration(seconds: 3)).then((_) {
      if(user != null){
        Get.offUntil(
          MaterialPageRoute(builder: (_) => HomeScreen()),
              (route) => false, // Removes all previous routes from the stack
        );
      }else{
        Get.off(()=>LoginScreen());
      }
    });
  }
}

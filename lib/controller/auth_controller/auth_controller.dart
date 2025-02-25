import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/register_screen/register_screen.dart';
import '../../view/user_details_screen/user_details_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;


  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }


  Future<void> login() async {
    if (!validateLoginInputs()) return;

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAll(() => const UserDetailsScreen()); // Navigate to next screen
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "An error occurred", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!validateRegistrationInputs()) return;

    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAll(() => const UserDetailsScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registration Failed", e.message ?? "An error occurred", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


  bool validateLoginInputs() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (!isValidEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Enter a valid email", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Password cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }


  bool validateRegistrationInputs() {

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (!isValidEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Enter a valid email", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Password cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Confirm password cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }


  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => RegisterScreen());
  }


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }
}

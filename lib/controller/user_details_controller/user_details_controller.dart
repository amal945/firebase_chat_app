import 'dart:io';
import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsController extends GetxController {
  static UserDetailsController instance = Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController fullNameController = TextEditingController();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxString profileImageUrl = "".obs;

  User? get user => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Pick Image from Gallery
// Pick Image from Camera or Gallery
  Future<void> pickImage({required ImageSource source}) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }


  // Upload Image to Firebase Storage & Get URL
  Future<String?> _uploadImage(File image) async {
    try {
      final ref = _storage.ref().child('user_profiles/${user?.uid}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Image upload failed", backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }


  Future<void> saveUserDetails() async {
    if (fullNameController.text.isEmpty && selectedImage.value == null) {
      Get.snackbar("Error", "Please enter your name or select an image",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl = profileImageUrl.value; // Keep existing URL

      // If user selects a new image, upload it
      if (selectedImage.value != null) {
        imageUrl = await _uploadImage(selectedImage.value!);
        if (imageUrl == null) throw "Image upload failed";
      }


      await _firestore.collection("users").doc(user?.uid).update({
        if (fullNameController.text.isNotEmpty) "fullName": fullNameController.text.trim(),
        if (imageUrl != null) "profileImageUrl": imageUrl,
      });

      // Update local state
      profileImageUrl.value = imageUrl!;

      Get.snackbar("Success", "Profile updated successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.to(HomeScreen());
    } catch (e) {
      Get.snackbar("Error", "Failed to save details",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


  // Fetch User Details
  Future<void> loadUserData() async {
    try {
      final snapshot = await _firestore.collection("users").doc(user?.uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        fullNameController.text = data["fullName"];
        profileImageUrl.value = data["profileImageUrl"];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void showImageSourceBottomSheet(BuildContext context, UserDetailsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                controller.pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
              title: const Text("From Gallery"),
              onTap: () {
                Get.back();
                controller.pickImage(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

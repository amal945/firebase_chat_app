import 'package:chat_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/user_details_controller/user_details_controller.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final UserDetailsController controller = Get.put(UserDetailsController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: controller.selectedImage.value != null
                      ? FileImage(controller.selectedImage.value!)
                      : (controller.profileImageUrl.value.isNotEmpty
                      ? NetworkImage(controller.profileImageUrl.value)
                      : null),
                  child: controller.selectedImage.value == null &&
                      controller.profileImageUrl.value.isEmpty
                      ? const Icon(Icons.person,
                      color: Colors.white, size: 100)
                      : null,
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 2),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => controller.showImageSourceBottomSheet(context, controller),
                      icon: const Icon(Icons.edit,
                          color: Colors.blueAccent, size: 24),
                    ),
                  ),
                ),
              ],
            )),
            kHeight35,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: controller.fullNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Enter Your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            kHeight35,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : controller.saveUserDetails,
                child: Obx(() => Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: controller.isLoading.value
                        ? Colors.grey
                        : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          controller.isLoading.value
                              ? "Saving..."
                              : "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        SizedBox(width: 90),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.arrow_forward_rounded,
                                color: Colors.blue),
                          ),
                        ),
                        kWidth5,
                      ],
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

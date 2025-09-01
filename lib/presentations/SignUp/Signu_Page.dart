import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voyager/widgets/CommonButton.dart';
import 'package:voyager/widgets/CommonInputFields.dart';
import '../../data/auth/controller/Auth_Controller.dart';
import '../../widgets/CustomAppBar.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final passwordVisibilityNotifier = ValueNotifier<bool>(true);
    final confirmPasswordVisibilityNotifier = ValueNotifier<bool>(true);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Create Account",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CommonInputField(
                controller: nameController,
                label: "Name",
                validator: (value) =>
                value == null || value.isEmpty ? "Name is required" : null,
              ),
              SizedBox(height: 5.h,),
              CommonInputField(
                controller: emailController,
                label: "Email",
                validator: (value) => value == null || !value.contains("@")
                    ? "Enter valid email"
                    : null,
              ),
              SizedBox(height: 5.h,),
              CommonInputField(
                controller: passwordController,
                label: "Password",
                isPassword: true,
                obscureNotifier: passwordVisibilityNotifier,
                validator: (value) => value != null && value.length < 6
                    ? "Minimum 6 characters"
                    : null,
              ),
              SizedBox(height: 5.h),
              CommonInputField(
                controller: confirmPasswordController,
                label: "Confirm Password",
                isPassword: true,
                obscureNotifier: confirmPasswordVisibilityNotifier,
                validator: (value) => value != passwordController.text
                    ? "Passwords do not match"
                    : null,
              ),
              const SizedBox(height: 20),
              Obx(() => CommonButton(
                label: "Sign Up",
                loading: controller.isLoading.value,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.signUp(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  }
                },
              )),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

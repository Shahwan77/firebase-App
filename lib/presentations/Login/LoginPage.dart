import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../data/auth/controller/Auth_Controller.dart';
import '../../widgets/CommonButton.dart';
import '../../widgets/CommonInputFields.dart';
import '../../widgets/CustomAppBar.dart';
import '../SignUp/Signu_Page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordVisibilityNotifier = ValueNotifier<bool>(true);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: const CustomAppBar(title: "Login"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30.h),
              CommonInputField(
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email is required";
                  if (!value.contains('@')) return "Enter a valid email";
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CommonInputField(
                label: "Password",
                controller: passwordController,
                isPassword: true,
                obscureNotifier: passwordVisibilityNotifier,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password is required";
                  if (value.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : CommonButton(
                label: "Login",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  }
                },
              )),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () => Get.to(() => const SignUpPage()),
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

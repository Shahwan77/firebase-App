import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final ValueNotifier<bool>? obscureNotifier;

  const CommonInputField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.obscureNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier ?? ValueNotifier<bool>(false),
      builder: (context, obscureText, _) {
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? obscureText : false,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 14.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                obscureNotifier!.value = !obscureText;
              },
            )
                : null,
          ),
          validator: validator,
        );
      },
    );
  }
}

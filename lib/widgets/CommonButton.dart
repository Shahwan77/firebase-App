import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  const CommonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue.shade700),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),),fixedSize: WidgetStatePropertyAll(Size(200.w, 50.h))),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(label,style: TextStyle(color: Colors.white),),
    );
  }
}
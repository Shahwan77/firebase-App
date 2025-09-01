import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/CustomAppBar.dart';
import '../AddEdit/AddEdit.dart';
import '../Home/Product_lIsts.dart';
import '../Home/controller/controller.dart';

class DashboardScreen extends StatelessWidget {
  final ProductController _controller = Get.put(ProductController());

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new_outlined),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure you want to logout?",
                textCancel: "Cancel",
                textConfirm: "Logout",
                confirmTextColor: Colors.white,
                onConfirm: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed('/login');
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final stats = _controller.getProductStats();

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Here is the summary of your products.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 24.h),

              // Statistics Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Total', stats['total'] ?? 0, Colors.blue.shade600),
                  _buildStatCard('Active', stats['active'] ?? 0, Colors.green.shade600),
                  _buildStatCard('Inactive', stats['inactive'] ?? 0, Colors.red.shade600),
                  _buildStatCard('Pending', stats['pending'] ?? 0, Colors.orange.shade600),
                ],
              ),
              SizedBox(height: 32.h),

              // Quick Actions Section
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(() => ProductListScreen()),
                      icon: const Icon(Icons.list,color: Colors.white),
                      label: const Text('View All Products',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(() => AddEditProductScreen()),
                      icon: const Icon(Icons.add,color: Colors.white,),
                      label: const Text('Add Product',style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Error Display
              if (_controller.hasError)
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _controller.error.value,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 4,
        shadowColor: Colors.grey.shade300,
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

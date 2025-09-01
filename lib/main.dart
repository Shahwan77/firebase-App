import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:voyager/routes/App_Pages/App_Pages.dart';
import 'package:voyager/routes/App_Routes/AppRoutes.dart';
import 'data/auth/bindings/AuthBinding.dart';
import 'data/auth/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Login',
        initialBinding: AuthBinding(),
        initialRoute: user != null ? AppRoutes.DashBoard : AppRoutes.Login,
        getPages: AppPages.lists,
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:voyager/presentations/DashBoard/dashBoard.dart';
import 'package:voyager/presentations/Home/Product_lIsts.dart';
import 'package:voyager/presentations/Login/LoginPage.dart';
import 'package:voyager/presentations/SignUp/Signu_Page.dart';
import 'package:voyager/routes/App_Routes/AppRoutes.dart';

class AppPages{
  static var lists = [
    GetPage(name: AppRoutes.Login, page: () =>  LoginPage(),),
    GetPage(name: AppRoutes.SignUp, page: () =>  SignUpPage(),),
    GetPage(name: AppRoutes.Home, page: () =>  ProductListScreen(),),
    GetPage(name: AppRoutes.DashBoard, page: () =>  DashboardScreen(),),
  ];
}
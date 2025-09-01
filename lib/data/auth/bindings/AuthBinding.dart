import 'package:get/get.dart';
import '../controller/Auth_Controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

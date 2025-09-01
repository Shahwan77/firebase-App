import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../presentations/DashBoard/dashBoard.dart';
import '../../../presentations/Home/Product_lIsts.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged in successfully");
      Get.offAll(() => DashboardScreen());
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName("Your Name Here");
      Get.snackbar("Success", "Account created successfully");
      Get.offAll(() => DashboardScreen());
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

}

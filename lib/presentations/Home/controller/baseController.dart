import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setError(String errorMessage) {
    error.value = errorMessage;
  }

  void clearError() {
    error.value = '';
  }

  bool get hasError => error.isNotEmpty;
}
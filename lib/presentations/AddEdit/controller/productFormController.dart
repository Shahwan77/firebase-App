import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Home/model/Product_Model.dart';
import 'package:uuid/uuid.dart';

class ProductFormController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxString price = ''.obs;
  final RxString quantity = ''.obs;
  final RxString imageUrl = ''.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxString category = ''.obs;
  final RxString status = 'active'.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  void initForm(Product? product) {
    if (product != null) {
      name.value = product.name;
      description.value = product.description;
      price.value = product.price.toString();
      quantity.value = product.quantity.toString();
      imageUrl.value = product.imageUrl ?? '';
      category.value = product.category;
      status.value = product.status;
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
      imageUrl.value = pickedFile.path; // For preview only (local path)
    } else {
      Get.snackbar("No Image", "You didn't select any image",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void clearForm() {
    name.value = '';
    description.value = '';
    price.value = '';
    quantity.value = '';
    imageUrl.value = '';
    pickedImage.value = null;
    category.value = '';
    status.value = 'active';
    error.value = '';
    formKey.currentState?.reset();
  }

  Product? validateAndGetProduct(String? productId) {
    if (!(formKey.currentState?.validate() ?? false)) {
      error.value = 'Please fix the errors in the form';
      return null;
    }

    final priceValue = double.tryParse(price.value);
    if (priceValue == null || priceValue <= 0) {
      error.value = 'Price must be greater than 0';
      return null;
    }

    final quantityValue = int.tryParse(quantity.value);
    if (quantityValue == null || quantityValue < 0) {
      error.value = 'Quantity cannot be negative';
      return null;
    }

    if (category.value.isEmpty) {
      error.value = 'Category is required';
      return null;
    }

    error.value = '';
    final newId = productId ?? const Uuid().v4();
    return Product(
      id: newId,
      name: name.value,
      description: description.value,
      price: priceValue,
      quantity: quantityValue,
      imageUrl: imageUrl.value.isEmpty ? null : imageUrl.value,
      category: category.value,
      status: status.value,
      createdAt: DateTime.now(),
    );
  }
}

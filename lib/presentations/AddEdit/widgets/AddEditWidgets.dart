import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyager/presentations/Home/controller/controller.dart';

import '../../Home/model/Product_Model.dart';
import '../controller/productFormController.dart';

class AddEditWidgets {
  static Widget buildHeader(bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? 'Update Product Details' : 'Create New Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEditing
              ? 'Make changes to your product information'
              : 'Fill in the details to add a new product to your catalog',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  static Widget buildImagePreview(ProductFormController formController) {
    return GestureDetector(
      onTap: () async {
        await formController.pickImage();
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Obx(() {
          // If user picks an image, show it
          if (formController.pickedImage.value != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                formController.pickedImage.value!,
                fit: BoxFit.cover,
              ),
            );
          }
          final url = formController.imageUrl.value.trim();
          if (url.isNotEmpty && url.startsWith('http')) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error_outline, size: 40);
                },
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[500]),
              const SizedBox(height: 8),
              Text('Add Image', style: TextStyle(color: Colors.grey[600])),
            ],
          );
        }),
      ),
    );
  }


  static Widget buildProductForm(ProductFormController formController,
      ProductController productController,) {
    return Form(
      key: formController.formKey,
      child: Column(
        children: [
          // Product Name
          buildFormField(
            label: 'Product Name',
            hint: 'Enter product name',
            icon: Icons.shopping_bag,
            controller: formController.name,
            validator: (value) {
              if (value == null || value
                  .trim()
                  .isEmpty) return 'Product name is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          buildFormField(
            label: 'Description',
            hint: 'Enter product description',
            icon: Icons.description,
            controller: formController.description,
            maxLines: 3,
            validator: (value) {
              if (value == null || value
                  .trim()
                  .isEmpty) return 'Description is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: buildFormField(
                  label: 'Price',
                  hint: '0.00',
                  icon: Icons.attach_money,
                  controller: formController.price,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  validator: (value) {
                    final v = value?.trim();
                    final parsed = double.tryParse(v ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Enter valid price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildFormField(
                  label: 'Quantity',
                  hint: '0',
                  icon: Icons.inventory,
                  controller: formController.quantity,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final v = value?.trim();
                    final parsed = int.tryParse(v ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Enter valid quantity';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildFormField(
            label: 'Image URL (Optional)',
            hint: 'https://example.com/image.jpg',
            icon: Icons.link,
            controller: formController.imageUrl,
          ),
          const SizedBox(height: 16),
          Obx(() {
            final categories = productController.categories
                .where((c) => c != 'All')
                .toList(growable: false) ??
                <String>[];
            return buildDropdown(
              label: 'Category',
              icon: Icons.category,
              value: formController.category.value,
              items: categories
                  .map(
                    (category) =>
                    DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
              )
                  .toList(),
              onChanged: (value) => formController.category.value = value ?? '',
            );
          }),
          const SizedBox(height: 16),
          Obx(() {
            const statuses = ['active', 'inactive', 'pending'];
            return buildDropdown(
              label: 'Status',
              icon: Icons.info,
              value: formController.status.value,
              items: statuses
                  .map(
                    (status) =>
                    DropdownMenuItem(
                      value: status,
                      child: Text(
                          status[0].toUpperCase() + status.substring(1)),
                    ),
              )
                  .toList(),
              onChanged: (value) =>
              formController.status.value = value ?? 'active',
            );
          }),
        ],
      ),
    );
  }

  static Widget buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    required RxString controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Obx(
          () =>
          TextFormField(
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.white,
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (value) => controller.value = value,
            initialValue: controller.value,
            validator: validator,
          ),
    );
  }

  static Widget buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          hint: Text(
              'Select $label', style: TextStyle(color: Colors.grey[500])),
        ),
      ),
    );
  }

  static Widget buildActionButtons(ProductFormController formController,
      ProductController productController,
      bool isEditing, {
        Product? existingProduct,
      }) {
    return Column(
      children: [
        Obx(() {
          if (formController.error.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    formController.error.value,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        Obx(() {
          final isLoading = productController.isLoading.value;
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () =>
                  saveProduct(
                    isEditing: isEditing,
                    formController: formController,
                    productController: productController,
                    existingProduct: existingProduct,
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : Text(
                isEditing ? 'Update Product' : 'Add Product',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  static Future<void> saveProduct({
    required bool isEditing,
    required ProductFormController formController,
    required ProductController productController,
    Product? existingProduct,
  }) async {
    final valid = formController.formKey.currentState?.validate() ?? false;
    if (!valid) {
      formController.error.value = 'Please fix the highlighted fields.';
      return;
    }
    formController.error.value = '';
    final dynamic idForEdit = isEditing ? existingProduct?.id : null;
    final Product? product = formController.validateAndGetProduct(idForEdit);
    if (product == null) {
      formController.error.value = 'Invalid product data.';
      return;
    }
    productController.isLoading.value = true;
    final bool success = isEditing
        ? await productController.updateProduct(product)
        : await productController.addProduct(product);
    productController.isLoading.value = false;
    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        isEditing
            ? 'Product updated successfully'
            : 'Product added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to ${isEditing ? 'update' : 'add'} product',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  static Future<void> showDeleteDialog({
    required ProductController productController,
    required Product? product,
  }) async {
    if (product == null) return;
    Get.defaultDialog(
      title: 'Delete Product',
      middleText: 'Are you sure you want to delete this product? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final success = await productController.deleteProduct(product.id);
        if (success) {
          Get.back(); // Close dialog
          Get.back(); // Close edit screen
          Get.snackbar(
            'Success',
            'Product deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete product. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      buttonColor: Colors.red,
    );
  }

  static Widget buildProductImage(String? imageUrl, {double? width, double? height}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    }
    if (imageUrl.startsWith('http')) {
      // Use CachedNetworkImage for online images
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error),
        ),
      );
    } else {
      return Image.file(
        File(imageUrl),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error),
        ),
      );
    }
  }

}
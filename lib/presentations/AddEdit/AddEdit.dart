import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyager/presentations/AddEdit/widgets/AddEditWidgets.dart';
import '../../widgets/CustomAppBar.dart';
import '../Home/controller/controller.dart';
import '../Home/model/Product_Model.dart';
import 'controller/productFormController.dart';

class AddEditProductScreen extends StatelessWidget {
  final Product? product;
  final ProductFormController formController = Get.put(ProductFormController());
  final ProductController productController = Get.find<ProductController>();

  AddEditProductScreen({this.product, super.key}) {
    if (product != null) {
      formController.initForm(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = product != null;
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: CustomAppBar(
        title: isEditing ? 'Edit Product' : 'Add New Product',
        showBackButton: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () {
                AddEditWidgets.showDeleteDialog(
                  productController: productController,
                  product: product,
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            AddEditWidgets.buildHeader(isEditing),
            const SizedBox(height: 24),
            AddEditWidgets.buildImagePreview(formController),
            const SizedBox(height: 24),
            AddEditWidgets.buildProductForm(formController,productController),
            const SizedBox(height: 32),
            AddEditWidgets.buildActionButtons(
              formController,
              productController,
              isEditing,
              existingProduct: isEditing ? product : null,
            ),
          ],
        ),
      ),
    );
  }

}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyager/presentations/AddEdit/controller/productFormController.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final ProductFormController formController = Get.put(ProductFormController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Obx(() {
            // ✅ 1. Check if a new image is picked in Add/Edit form
            if (formController.pickedImage.value != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  formController.pickedImage.value!,
                  fit: BoxFit.contain,
                ),
              );
            }

            // ✅ 2. Check if it's an online image
            if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  size: 80,
                  color: Colors.white,
                ),
              );
            }

            // ✅ 3. Otherwise, assume it's a local file path
            if (imageUrl.isNotEmpty) {
              final file = File(imageUrl);
              if (file.existsSync()) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    file,
                    fit: BoxFit.contain,
                  ),
                );
              }
            }

            // ✅ 4. Fallback: No image available
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, size: 80, color: Colors.grey[500]),
                const SizedBox(height: 8),
                Text('No Image Available', style: TextStyle(color: Colors.grey[400])),
              ],
            );
          }),
        ),
      ),
    );
  }
}

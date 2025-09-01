import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voyager/data/services/pdf/pdfReport.dart';
import 'package:voyager/presentations/AddEdit/widgets/AddEditWidgets.dart';

import '../../data/services/csv/csvreport.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/FullScreen_image.dart';
import '../AddEdit/AddEdit.dart';
import 'controller/controller.dart';
import 'model/Product_Model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ProductController _controller =
        Get.find<ProductController>(); // Add this

    return Scaffold(
      appBar: CustomAppBar(
        title: product.name,
        showBackButton: true,
        actions: [
          // EDIT BUTTON - Add this icon button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => AddEditProductScreen(product: product));
            },
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProduct,
            tooltip: 'Share Product',
          ),
          // DELETE BUTTON - Optional: Add delete functionality too
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirmed = await Get.defaultDialog(
                title: "Delete Product",
                middleText: "Are you sure you want to delete ${product.name}?",
                textCancel: "Cancel",
                textConfirm: "Delete",
                confirmTextColor: Colors.white,
              );

              if (confirmed == true) {
                final success = await _controller.deleteProduct(product.id);
                if (success) {
                  Get.back(); // Go back to previous screen
                  Get.snackbar('Success', 'Product deleted successfully');
                }
              }
            },
            tooltip: 'Delete Product',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Hero(
                tag: 'product-${product.id}',
                child: GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        FullScreenImagePage(imageUrl: product.imageUrl ?? ''));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: AddEditWidgets.buildProductImage(
                        product.imageUrl,
                        width: 300.w,
                        height: 280.h,
                      )),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      ReportService.showProductPdfPreview([product]); // wrap single product in list
                    },
                    icon: Icon(
                      Icons.picture_as_pdf,
                      size: 30.sp,
                      color: Colors.red,
                    ),
                  ),

                  IconButton(
                      onPressed: () {
                        CsvReportService.generateProductCsv([product]);
                      },
                      icon: Icon(
                        Icons.document_scanner,
                        size: 30.sp,
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Add status display if you have status field
                    Text(
                      'Status: ${product.status[0].toUpperCase()}${product.status.substring(1)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _getStatusColor(product.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(product.category),
                          backgroundColor: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, color: Colors.blue),
                  SizedBox(width: 10.w),
                  Text(
                    'Available Quantity: ${product.quantity}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Add created date display if you have createdAt field
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.blue),
                  SizedBox(width: 10.w),
                  Text(
                    'Created: ${_formatDate(product.createdAt)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _shareProduct() async {
    final subject = 'Check out this product: ${product.name}';
    final body = '''
Product: ${product.name}
Price: \$${product.price.toStringAsFixed(2)}
Description: ${product.description}

${product.imageUrl != null ? 'Image: ${product.imageUrl}' : ''}
''';

    final uri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch email');
    }
  }
}

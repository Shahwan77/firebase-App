import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:voyager/widgets/CustomAppBar.dart';

import '../../../presentations/Home/model/Product_Model.dart';

class ReportService {
  static void showProductPdfPreview(List<Product> products) {
    Get.to(() => PdfPreviewScreen(products: products));
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final List<Product> products;
  const PdfPreviewScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(title: 'Product Repor Preview',showBackButton: true,),
      body: PdfPreview(
        build: (format) {
          final pdf = pw.Document();

          pdf.addPage(
            pw.Page(
              pageFormat: format,
              build: (context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Product Report',
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 16),
                    pw.Table.fromTextArray(
                      headers: ['ID', 'Name', 'Status', 'Created'],
                      data: products.map((p) => [
                        p.id.toString(),
                        p.name,
                        p.status,
                        _formatDate(p.createdAt),
                      ]).toList(),
                    ),
                  ],
                );
              },
            ),
          );

          return pdf.save();
        },
      ),
    );
  }

  // Helper to format DateTime
  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

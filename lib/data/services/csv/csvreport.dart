import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../../../presentations/Home/model/Product_Model.dart';

class CsvReportService {
  static Future<void> generateProductCsv(List<Product> products) async {
    List<List<String>> rows = [
      ['ID', 'Name', 'Status', 'Created Date']
    ];

    for (var p in products) {
      rows.add([p.id.toString(), p.name, p.status, p.createdAt.toString()]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/product_report.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    print('CSV saved at $path');
  }
}

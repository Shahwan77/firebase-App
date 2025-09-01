// model/Product_Model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String category;
  final String status; // Add status field
  final DateTime createdAt; // Add createdDate field

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.category,
    required this.status, // Add to constructor
    required this.createdAt, // Add to constructor
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: (data['quantity'] ?? 0).toInt(),
      imageUrl: data['imageUrl'],
      category: data['category'] ?? '',
      status: data['status'] ?? 'active', // Default status
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'category': category,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
// service/product_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voyager/presentations/Home/model/Product_Model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getAllProducts() {
    return _firestore
        .collection('product')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList());
  }

  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection('product')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList());
  }

  Stream<List<String>> getAllCategories() {
    return _firestore.collection('product')
        .snapshots()
        .map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => doc['category'] as String?)
          .where((category) => category != null)
          .map((category) => category!)
          .toSet()
          .toList();
      return categories..insert(0, 'All');
    });
  }
  Future<void> addProduct(Product product) async {
    await _firestore.collection('product').add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _firestore.collection('product').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('product').doc(productId).delete();
  }
}
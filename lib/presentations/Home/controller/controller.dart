import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../data/auth/service_locator.dart';
import '../model/Product_Model.dart';
import '../service/product_repo.dart';
import 'baseController.dart';

class ProductController extends BaseController {
  final ProductRepository _repository = getIt<ProductRepository>();
  final RxList<Product> products = <Product>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    fetchProducts();
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      setLoading(true);
      clearError();

      final stream = selectedCategory.value == 'All'
          ? _repository.getAllProducts()
          : _repository.getProductsByCategory(selectedCategory.value);

      stream.listen((productList) {
        products.assignAll(productList);
        setLoading(false);
      }, onError: (error) {
        setError('Failed to load products: $error');
        setLoading(false);
      });
    } catch (e) {
      setError('Failed to load products: $e');
      setLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      _repository.getAllCategories().listen((categoryList) {
        categories.assignAll(categoryList);
      }, onError: (error) {
        setError('Failed to load categories: $error');
      });
    } catch (e) {
      setError('Failed to load categories: $e');
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchProducts();
  }

  // Add these methods to your existing ProductController
  Future<bool> addProduct(Product product) async {
    try {
      isLoading(true);
      clearError();

      await _repository.addProduct(product);
      await fetchProducts(); // Refresh the list

      return true;
    } catch (e) {
      setError('Failed to add product: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      isLoading(true);
      clearError();

      await _repository.updateProduct(product);
      await fetchProducts(); // Refresh the list

      return true;
    } catch (e) {
      setError('Failed to update product: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      isLoading(true);
      clearError();

      await _repository.deleteProduct(productId);
      await fetchProducts(); // Refresh the list

      return true;
    } catch (e) {
      setError('Failed to delete product: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Get statistics for dashboard
  Map<String, int> getProductStats() {
    final total = products.length;
    final active = products.where((p) => p.status == 'active').length;
    final inactive = products.where((p) => p.status == 'inactive').length;

    return {
      'total': total,
      'active': active,
      'inactive': inactive,
    };
  }
}
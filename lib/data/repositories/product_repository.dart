import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/data/services/product_service.dart';

class ProductRepository {
  final ProductService _service = ProductService();

  // Fetch all products
  Future<List<ProductModel>> fetchProducts() async {
    try {
      return await _service.getProducts();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        return await _service.getProducts();
      }
      return await _service.searchProducts(query);
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Get product detail
  Future<ProductModel> getProductDetail(int id) async {
    try {
      return await _service.getProductById(id);
    } catch (e) {
      throw Exception('Failed to get product detail: $e');
    }
  }

  // Get categories
  Future<List<String>> getCategories() async {
    try {
      return await _service.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      return await _service.getProductsByCategory(category);
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }
}

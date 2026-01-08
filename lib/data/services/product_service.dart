// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/data/services/api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    final data = await _apiService.get('/products');
    final List list = data['products'];
    return list.map((item) => ProductModel.fromJson(item)).toList();
  }

  // Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    final data = await _apiService.get('/products/search?q=$query');
    final List list = data['products'];
    return list.map((item) => ProductModel.fromJson(item)).toList();
  }

  // Get product by ID
  Future<ProductModel> getProductById(int id) async {
    final data = await _apiService.get('/products/$id');
    return ProductModel.fromJson(data);
  }

  // Get categories
  Future<List<String>> getCategories() async {
    // Note: Categories endpoint returns array directly
    // Using the correct endpoint
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/category-list'),
    );
    
    if (response.statusCode == 200) {
      final List categories = jsonDecode(response.body);
      return categories.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final data = await _apiService.get('/products/category/$category');
    final List list = data['products'];
    return list.map((item) => ProductModel.fromJson(item)).toList();
  }

  Future<bool> addProduct(ProductModel product) async {
    try {
      final data = await _apiService.post(
        '/products/add',
        product.toJson(),
      );

      return data.isNotEmpty;
    } catch (e) {
      print("Add Product Error: $e");
      return false;
    }
  }

  Future<bool> markAsSold(int productId) async {
    return true;
  }

  Future<bool> deleteProduct(int productId) async {
    return true;
  }
}
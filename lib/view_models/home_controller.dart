import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/models/user_model.dart';
import 'package:uap_reusea/data/repositories/product_repository.dart';
import 'package:uap_reusea/data/repositories/user_repository.dart';

class HomeController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  final UserRepository _userRepository = UserRepository();

  // Observable variables
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final categories = <String>[].obs;
  final users = <UserModel>[].obs; // Store users from API
  final isLoading = false.obs;
  final isSearching = false.obs;
  final selectedCategory = Rx<String?>(null);
  final searchQuery = ''.obs;

  // Text controller for search
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }

  // Initialize - fetch users and products
  Future<void> _initialize() async {
    await Future.wait([
      fetchUsers(),
      fetchProducts(),
      fetchCategories(),
    ]);
  }

  // Fetch users from API
  Future<void> fetchUsers() async {
    try {
      final result = await _userRepository.getUsers(10);
      users.assignAll(result);
    } catch (e) {
      // Silent fail - will use fallback if needed
      // ignore: avoid_print
      print('Failed to load users: $e');
    }
  }

  // Get seller info for a product
  UserModel getSellerForProduct(int productId) {
    if (users.isEmpty) {
      return UserModel.dummy();
    }
    return users[productId % users.length];
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await _repository.fetchProducts();
      products.assignAll(result);
      filteredProducts.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      final result = await _repository.getCategories();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      if (selectedCategory.value != null) {
        await filterByCategory(selectedCategory.value!);
      } else {
        filteredProducts.assignAll(products);
      }
      return;
    }

    try {
      isSearching.value = true;
      final result = await _repository.searchProducts(query);
      filteredProducts.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSearching.value = false;
    }
  }

  // Filter by category
  Future<void> filterByCategory(String category) async {
    selectedCategory.value = category;
    
    try {
      isLoading.value = true;
      final result = await _repository.getProductsByCategory(category);
      filteredProducts.assignAll(result);
      
      // Apply search filter if there's a search query
      if (searchQuery.value.isNotEmpty) {
        filteredProducts.value = filteredProducts
            .where((product) => product.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to filter products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear category filter
  void clearCategoryFilter() {
    selectedCategory.value = null;
    if (searchQuery.value.isNotEmpty) {
      searchProducts(searchQuery.value);
    } else {
      filteredProducts.assignAll(products);
    }
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    if (selectedCategory.value != null) {
      filterByCategory(selectedCategory.value!);
    } else {
      filteredProducts.assignAll(products);
    }
  }

  // Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    await Future.wait([
      fetchUsers(),
      fetchProducts(),
    ]);
    if (selectedCategory.value != null) {
      await filterByCategory(selectedCategory.value!);
    }
  }
}
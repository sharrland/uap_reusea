import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uap_reusea/data/repositories/product_repository.dart';
import 'package:uap_reusea/models/product_model.dart';

class AddProductController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  /// Category (from API)
  RxList<String> categories = <String>[].obs;
  RxString selectedCategory = ''.obs;
  RxBool isCategoryLoading = false.obs;

  /// Media
  final ImagePicker _picker = ImagePicker();
  RxList<File> mediaFiles = <File>[].obs;

  /// State
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isCategoryLoading.value = true;
      final result = await _repo.getCategories();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    } finally {
      isCategoryLoading.value = false;
    }
  }

  void onCategorySelected(String? value) {
    if (value != null) {
      selectedCategory.value = value;
    }
  }

  Future<void> pickMedia() async {
    if (mediaFiles.length >= 3) {
      Get.snackbar("Limit", "Maximum 3 photos/videos");
      return;
    }

    final XFile? file =
        await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      mediaFiles.add(File(file.path));
    }
  }

  Future<void> addProduct() async {
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategory.value.isEmpty ||
        mediaFiles.isEmpty) {
      Get.snackbar("Error", "Please complete the product data");
      return;
    }

    try {
      isLoading.value = true;

      final product = ProductModel(
        id: 0,
        title: titleController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        description: descriptionController.text,
        category: selectedCategory.value,

        thumbnail: '',
        discountPercentage: 0.0,
        stock: 0,
        rating: 0.0,
        images: [],
      );

      final success = await _repo.addProduct(product);

      if (success) {
        Get.back();
        Get.snackbar("Success", "Product uploaded successfully");
      } else {
        Get.snackbar("Failed", "Product upload failed");
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void removeMedia(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      mediaFiles.removeAt(index);
    }
  }

}
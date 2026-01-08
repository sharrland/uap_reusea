import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/view_models/add_product_controller.dart';
import 'package:flutter/foundation.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Upload Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0.5,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos & Videos
              const Text(
              "Photos & Videos",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: List.generate(
                  3,
                  (index) {
                    if (index < controller.mediaFiles.length) {
                      return Expanded(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                              height: 90,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: kIsWeb
                                  ? Image.network(
                                      controller.mediaFiles[index].path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      controller.mediaFiles[index],
                                      fit: BoxFit.cover,
                                    ),
                            ),

                            // Hapus Foto
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => controller.removeMedia(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Expanded(
                      child: GestureDetector(
                        onTap: controller.pickMedia,
                        child: Container(
                          margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                          height: 90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade600),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

              const SizedBox(height: 24),

              // Category
              const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return DropdownButtonFormField<String>(
                  hint: const Text("Select category"),
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  items: controller.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: controller.onCategorySelected,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Name
              const Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  hintText: "Give a name to your product",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Price
              const Text(
                "Price",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Set your product price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      "Tell buyers why you're selling this item and include details that might interest them",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Upload Button
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB83A57),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: controller.addProduct,
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
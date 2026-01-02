import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/view_models/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE), // ✅ Consistent color
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.products.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB83556)),
                  );
                }

                if (controller.filteredProducts.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  color: const Color(0xFFB83556),
                  onRefresh: controller.refreshProducts,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      return _buildProductCard(product, controller);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Obx(() => Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.searchProducts(value),
              style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade600),
                        onPressed: controller.clearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          )),

          const SizedBox(height: 12),

          // Category Dropdown
          Obx(() => Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFFB83556), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedCategory.value,
                hint: const Text(
                  'All Categories',
                  style: TextStyle(
                    color: Color(0xFFB83556),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFB83556),
                  size: 24,
                ),
                isExpanded: true,
                alignment: AlignmentDirectional.centerStart,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  ...controller.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  if (value == null) {
                    controller.clearCategoryFilter();
                  } else {
                    controller.filterByCategory(value);
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'All Categories',
                        style: TextStyle(
                          color: Color(0xFFB83556),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    ...controller.categories.map((category) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Color(0xFFB83556),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      );
                    }),
                  ];
                },
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProductCard(product, HomeController controller) {
    // ✅ Get seller from API
    final seller = controller.getSellerForProduct(product.id);

    return GestureDetector(
      onTap: () => Get.toNamed('/product-detail', arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                child: Image.network(
                  product.thumbnail,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Icon(Icons.image, size: 40, color: Colors.grey.shade400),
                    );
                  },
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nama Produk
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Harga - USD
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Row User (Foto + Nama) - ✅ From API
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300, width: 0.5),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            seller.avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFB83556),
                                child: const Icon(Icons.person, color: Colors.white, size: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          seller.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'Inter',
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
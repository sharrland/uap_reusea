import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/view_models/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      floatingActionButton: Obx(
        () => controller.isOnSale.value
            ? FloatingActionButton(
                backgroundColor: Colors.pink,
                onPressed: () {
                   Get.toNamed('/add-product');
                },
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
      ),

      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Get.toNamed('/settings');
                    },
                  ),
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  controller.user.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.user.fullName,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Toggle Button
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: _buildTab(
                          title: 'On Sale',
                          active: controller.isOnSale.value,
                          onTap: () => controller.showOnSale(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _buildTab(
                          title: 'Sold',
                          active: !controller.isOnSale.value,
                          onTap: () => controller.showSold(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),

                const SizedBox(height: 16),

                // Product Grid
               GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.currentProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = controller.currentProducts[index];
                  return _productCard(
                    product, 
                    isSold: !controller.isOnSale.value
                  );
                },
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTab({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.pink : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.pink,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.pink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _productCard(product, {required bool isSold}) {
    return GestureDetector(
    onTap: () => Get.toNamed(
      '/tabs-product-detail',
      arguments: {
        'product': product,
        'isSold': isSold,
      },
    ),

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
            // IMAGE
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                    child: Image.network(
                      product.thumbnail,
                      width: double.infinity,
                      fit: BoxFit.contain, 
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),

                  // SOLD BADGE 
                  if (isSold)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 28,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFBFE7E2),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'SOLD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PRODUCT INFO 
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul produk
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

                  // Harga
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
                  const Text(
                    'View Details',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
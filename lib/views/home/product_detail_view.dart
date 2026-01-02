import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/models/chat_model.dart';
import 'package:uap_reusea/view_models/chat_controller.dart';
import 'package:uap_reusea/view_models/home_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments as ProductModel;
    final homeController = Get.find<HomeController>();
    
    // ✅ Get seller from API
    final seller = homeController.getSellerForProduct(product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageGallery(product),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama Produk
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Inter',
                              color: Colors.black,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Harga - USD
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Deskripsi
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ✅ REMOVED: Fabric & Available Size (hanya Description)

                          _buildSellerCard(seller),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomActions(product, seller),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(ProductModel product) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
          child: Image.network(
            product.thumbnail,
            width: double.infinity,
            height: 322,
            fit: BoxFit.contain, // ✅ Changed from cover
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 322,
                color: Colors.grey.shade100,
                child: Icon(Icons.image, size: 80, color: Colors.grey.shade400),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerCard(seller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB83556), width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                seller.avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFB83556),
                    child: const Icon(Icons.storefront, color: Colors.white, size: 24),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.username,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.verified, size: 14, color: Color(0xFFB83556)),
                    SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ProductModel product, seller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  final chatController = Get.put(ChatController());
                  final chatId = 'chat_${product.id}';
                  
                  // ✅ Check if chat already exists
                  final existingChatIndex = chatController.chats.indexWhere((c) => c.id == chatId);
                  
                  final chat = ChatModel(
                    id: chatId,
                    sellerId: 'seller_${product.id}',
                    sellerName: seller.username,
                    sellerAvatar: seller.avatar,
                    lastMessage: '',
                    time: 'Now',
                    unreadCount: 0,
                    product: product,
                  );
                  
                  // ✅ Add to chat list only if doesn't exist
                  if (existingChatIndex == -1) {
                    chatController.chats.add(chat);
                  }
                  
                  Get.toNamed('/chat-room', arguments: chat);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFB83556), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Color(0xFFB83556),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/make-offer', arguments: product),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFB83556),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Make Offer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/models/chat_model.dart';
import 'package:uap_reusea/view_models/chat_controller.dart';
import 'package:uap_reusea/view_models/tabs_product_detail_controller.dart';

class TabsProductDetailView extends StatelessWidget {
  const TabsProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabsProductDetailController());
    final ProductModel product = controller.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptions(controller),
          ),
        ],
      ),
      body: _buildBody(product),
    );
  }

  // Body
  Widget _buildBody(ProductModel product) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(product),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildChatButton(product),
      ],
    );
  }

  // Image
  Widget _buildImage(ProductModel product) {
    return Image.network(
      product.thumbnail,
      width: double.infinity,
      height: 320,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        height: 320,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image, size: 80),
      ),
    );
  }

  // Chat Button
  Widget _buildChatButton(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB83A57),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: () {
            final chatController = Get.put(ChatController());
            final chatId = 'chat_${product.id}';

            final exists = chatController.chats
                .any((element) => element.id == chatId);

            final chat = ChatModel(
              id: chatId,
              sellerId: '', 
              sellerName: product.title,
              sellerAvatar: '',
              lastMessage: '',
              time: 'Now',
              unreadCount: 0,
              product: product,
            );

            if (!exists) {
              chatController.chats.add(chat);
            }

            Get.toNamed('/chat', arguments: chat);
          },
          child: const Text(
            'Chat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Options
  void _showOptions(TabsProductDetailController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!controller.isSold) ...[
              _tile(Icons.edit, 'Edit listing details', controller.editProduct),
              _tile(Icons.check_circle, 'Mark as sold', controller.markAsSold),
            ],
            _tile(
              Icons.delete,
              'Delete listing',
              controller.deleteProduct,
              color: Colors.red,
            ),
            const Divider(),
            _tile(Icons.close, 'Cancel', () => Get.back()),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}

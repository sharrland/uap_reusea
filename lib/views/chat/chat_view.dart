import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/view_models/chat_controller.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE), // ✅ Consistent color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // ✅ Always show empty state if no chats (no dummy data)
        if (controller.chats.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: const Color(0xFFB83556),
          onRefresh: controller.refreshChats,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: controller.chats.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
              indent: 76,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final chat = controller.chats[index];
              return _buildChatItem(chat, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildChatItem(chat, ChatController controller) {
    final sellerId = int.tryParse(chat.sellerId.replaceAll('seller_', '')) ?? 1;
    final sellerAvatarUrl = chat.sellerAvatar.isNotEmpty 
        ? chat.sellerAvatar 
        : 'https://i.pravatar.cc/150?img=${sellerId % 70 + 1}';
    
    // Format tanggal dd/MM
    final now = DateTime.now();
    String formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';

    // Handle dynamic product (bisa Map atau ProductModel)
    String productTitle = '';
    if (chat.product != null) {
      final product = chat.product;
      productTitle = product is Map ? product['title']?.toString() ?? '' : product.title?.toString() ?? '';
    }

    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          controller.openChatRoom(chat);
          Get.toNamed('/chat-room', arguments: chat);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Profil (48×48, circle)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: ClipOval(
                  child: Image.network(
                    sellerAvatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFB83556),
                        child: const Icon(
                          Icons.storefront,
                          color: Colors.white,
                          size: 26,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Chat Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Nama user + Tanggal
                    Row(
                      children: [
                        // Nama User - SemiBold
                        Expanded(
                          child: Text(
                            chat.sellerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Tanggal (dd/MM)
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Nama Produk - SemiBold (1 baris, ellipsis)
                    if (productTitle.isNotEmpty)
                      Text(
                        productTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 2),

                    // Last Chat / Status Offer - abu-abu
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.lastMessage,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Inter',
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Unread Badge (jika ada)
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            constraints: const BoxConstraints(minWidth: 20),
                            height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFB83556),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                chat.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with sellers',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
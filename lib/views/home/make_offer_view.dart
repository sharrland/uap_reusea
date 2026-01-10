import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/models/chat_model.dart';
import 'package:uap_reusea/view_models/user_controller.dart';
import 'package:uap_reusea/view_models/chat_controller.dart';
import 'package:uap_reusea/view_models/home_controller.dart'; 

class MakeOfferView extends StatefulWidget {
  const MakeOfferView({super.key});

  @override
  State<MakeOfferView> createState() => _MakeOfferViewState();
}

class _MakeOfferViewState extends State<MakeOfferView> {
  final _offerController = TextEditingController();
  final userController = Get.find<UserController>();
  late ProductModel product;
  String? _errorMessage;

  
  String _getSellerName(int productId) {
    try {
      final homeController = Get.put(HomeController()); 
      final seller = homeController.getSellerForProduct(productId);
      return seller.username;
    } catch (e) {
      // Fallback if error
      return '@user$productId';
    }
  }

  String _getSellerAvatar(int productId) {
    try {
      final homeController = Get.put(HomeController()); 
      final seller = homeController.getSellerForProduct(productId);
      return seller.avatar;
    } catch (e) {
      // Fallback if error
      return 'https://i.pravatar.cc/150?img=${(productId % 70) + 1}';
    }
  }

  @override
  void initState() {
    super.initState();
    product = Get.arguments as ProductModel;
  }

  @override
  void dispose() {
    _offerController.dispose();
    super.dispose();
  }

  void _validateAndSubmitOffer() {
    setState(() => _errorMessage = null);

    final offerText = _offerController.text.trim();

    if (offerText.isEmpty) {
      setState(() => _errorMessage = 'Please enter your offer price');
      return;
    }

    final offerPrice = double.tryParse(offerText);
    if (offerPrice == null) {
      setState(() => _errorMessage = 'Please enter a valid number');
      return;
    }

    if (offerPrice >= product.price) {
      setState(() => _errorMessage = 'Your offer must be lower than \$${product.price.toStringAsFixed(2)}');
      return;
    }

    final minPrice = product.price * 0.8;
    if (offerPrice < minPrice) {
      setState(() => _errorMessage = 'Your offer is too low. Minimum offer is \$${minPrice.toStringAsFixed(2)}  (80% of original price)');
      return;
    }

    _showValidationDialog(offerPrice);
  }

  void _showValidationDialog(double offerPrice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text(
          'Submit Offer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        content: Text(
          'Are you sure you want to offer \$${offerPrice.toStringAsFixed(2)}?',
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFFB83556),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              
              
              final chatController = Get.put(ChatController());
              
              
              final chatId = 'chat_${product.id}';
              final productId = product.id.toString();
              final sellerName = _getSellerName(product.id);
              final sellerAvatar = _getSellerAvatar(product.id);
              
             
              final existingChatIndex = chatController.chats.indexWhere((c) => c.id == chatId);
              
              await chatController.makeOffer(chatId, productId, offerPrice);
              
              
              final chat = ChatModel(
                id: chatId,
                sellerId: 'seller_${product.id}',
                sellerName: sellerName,
                sellerAvatar: sellerAvatar,
                lastMessage: 'Made an offer \$${offerPrice.toStringAsFixed(2)}',
                time: 'Now',
                unreadCount: 0,
                product: product,
              );
              
              
              if (existingChatIndex == -1) {
                chatController.chats.add(chat);
              } else {
               
                chatController.chats[existingChatIndex] = chat;
              }
              
             
              Get.back(); // Close make offer
              Get.toNamed('/chat-room', arguments: chat);
            },
            child: const Text(
              'Submit Offer',
              style: TextStyle(
                color: Color(0xFF38B356),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Stack(
        children: [
          // Overlay - tap to close
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(color: Colors.transparent),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'Make an Offer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Info Harga Seller
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Seller Price:',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Harga yang ditawar (center, besar)
                      const Text(
                        'Your Offer',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _errorMessage != null
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: _offerController,
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            prefixStyle: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                            hintText: '0.00',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onChanged: (value) {
                            if (_errorMessage != null) {
                              setState(() => _errorMessage = null);
                            }
                          },
                        ),
                      ),

                      // Error Message
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Make Offer Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _validateAndSubmitOffer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB83556),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Make Offer',
                            style: TextStyle(
                              fontSize: 16,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
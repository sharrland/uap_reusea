import 'package:get/get.dart';
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/data/repositories/product_repository.dart';

class TabsProductDetailController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  late ProductModel product;
  late bool isSold;

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>;
    product = args['product'];
    isSold = args['isSold'];
    super.onInit();
  }

  void editProduct() {
    Get.toNamed('/edit-product', arguments: product);
  }

  void markAsSold() async {
    final success = await _repository.markAsSold(product.id);
    if (success) {
      Get.back(); 
      Get.back(); 
    }
  }

  void deleteProduct() async {
    final success = await _repository.deleteProduct(product.id);
    if (success) {
      Get.back();
      Get.back();
    }
  }

}

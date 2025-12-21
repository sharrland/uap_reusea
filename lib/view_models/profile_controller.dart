import 'package:get/get.dart';
import 'package:uap_reusea/data/repositories/product_repository.dart';
import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/models/user_model.dart';

class ProfileController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  RxBool isOnSale = true.obs;

  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> currentProducts = <ProductModel>[].obs;

  final user = UserModel(
    username: '@bravestar71',
    fullName: 'Karina Stephia',
    avatar: 'https://i.pravatar.cc/300',
  );

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    final result = await _repository.fetchProducts();
    allProducts.assignAll(result.take(8));
    showOnSale();
  }

  void showOnSale() {
    isOnSale.value = true;
    currentProducts.assignAll(
      allProducts
      .where((p) => p.stock >= 50 && p.stock <= 100)
      .toList(),
    );
  }

  void showSold() {
    isOnSale.value = false;
    currentProducts.assignAll(
      allProducts.where((p) => p.stock < 50).toList(),
    );
  }
}

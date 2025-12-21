import 'package:uap_reusea/models/product_model.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService _service = ProductService();

  Future<List<ProductModel>> fetchProducts() {
    return _service.getProducts();
  }
}

import 'package:uap_reusea/models/product_model.dart';
import 'package:uap_reusea/data/services/api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  Future<List<ProductModel>> getProducts() async {
    final data = await _apiService.get('/products');

    final List list = data['products'];

    return list
        .map((item) => ProductModel.fromJson(item))
        .toList();
  }

}
import 'package:teslo_shop/features/products/domain/entities/products.dart';

abstract class ProductsRepository {

  Future<List<Products>> getProductsbyPage({int limit = 10, int offset = 0});
  Future<Products> getProductById(String id);
  Future<Products> createUpdateProduct(Map<String, dynamic> productLike );
}
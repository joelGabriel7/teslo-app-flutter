import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  @override
  Future<Products> createUpdateProduct(Map<String, dynamic> productLike) {
    return datasource.createUpdateProduct(productLike);
  }

  @override
  Future<Products> getProductById(String id) {
    return datasource.getProductById(id);
  }

  @override
  Future<List<Products>> getProductsbyPage({int limit = 10, int offset = 0}) {
    return datasource.getProductsbyPage(limit: limit, offset: offset);
  }
}

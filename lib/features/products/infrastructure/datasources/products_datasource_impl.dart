import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/enviroments.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;
  ProductDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(baseUrl: Enviroments.apiUrl, headers: {
          'Authorization': 'Bearer $accessToken',
        }));

  @override
  Future<Products> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Products> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Products>> getProductsbyPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get('/products?limit=$limit&offset=$offset');
    final List<Products> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;

  }
}

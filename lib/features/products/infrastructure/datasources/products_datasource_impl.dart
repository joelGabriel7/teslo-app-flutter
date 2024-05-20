import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/enviroments.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_error.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;
  ProductDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(baseUrl: Enviroments.apiUrl, headers: {
          'Authorization': 'Bearer $accessToken',
        }));

  @override
  Future<Products> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';
      productLike.remove('id');

      final response = await dio.request(
       url,
       data: productLike,
       options: Options(
        method: method
      ));

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Products> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ProductNotFound();
      throw Exception('Error loading product');
    } catch (e) {
      throw ProductNotFound();
    }
  }

  @override
  Future<List<Products>> getProductsbyPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio.get('/products?limit=$limit&offset=$offset');
    final List<Products> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'products_repository_provider.dart';

//! Provider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsReporistoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

//! notifier

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductsNotifier({
    required this.productsRepository
    }): super(ProductsState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
   try{
     final product =await productsRepository.createUpdateProduct(productLike);
     final isProductExist = state.products.any((element) => element.id == product.id);
      if (!isProductExist){
        state = state.copyWith(products:[...state.products, product]);
        return true;
      }

      if (isProductExist){
        final products = state.products.map((e) => e.id == product.id ? product : e).toList();
        state = state.copyWith(products: products);
        return true;
      } 
      return true;
    // loadNextPage();
   } catch (e){
      return false;
   }
  }
  Future loadNextPage() async {

    if (state.isLoading || state.islastPage) return;
    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsbyPage(
        limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        islastPage: true,
      );
      return;
    }
    state = state.copyWith(
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}

//! State

class ProductsState {
  final bool islastPage;
  final bool isLoading;
  final int limit;
  final int offset;
  final List<Products> products;

  ProductsState({
      this.islastPage = false,
      this.isLoading = false,
      this.limit = 10,
      this.offset = 0,
      this.products = const []
      });
  ProductsState copyWith({
    bool? islastPage,
    bool? isLoading,
    int? limit,
    int? offset,
    List<Products>? products,
  }) => ProductsState(
        islastPage: islastPage ?? this.islastPage,
        isLoading: isLoading ?? this.isLoading,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        products: products ?? this.products,
      );
}

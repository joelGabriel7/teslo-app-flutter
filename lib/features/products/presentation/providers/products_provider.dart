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

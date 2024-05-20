import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

//*Provider

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsrepository = ref.watch(productsReporistoryProvider);
  return ProductNotifier(
      productsrepository: productsrepository, productId: productId);
});
//*Notifier

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsrepository;
  ProductNotifier({required this.productsrepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProdut();
  }

   Products newEmptyProduct() {
    return Products(
      id: 'new', 
      title: '', 
      price: 0, 
      description: '', 
      slug: '', 
      stock: 0, 
      sizes: [], 
      gender: 'men', 
      tags: [], 
      images: [],
    );
  }




  Future<void> loadProdut() async {
    if (state.id == 'new') {
      state = state.copyWith(isLoading: false, product: newEmptyProduct());
      return;
    }

    try {
      final product = await productsrepository.getProductById(state.id);
      state = state.copyWith(product: product, isLoading: false);
    } catch (e) {
      throw Exception('Error loading product');
    }
  }
}

//*State
class ProductState {
  final String id;
  final Products? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Products? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
          id: id ?? this.id,
          product: product ?? this.product,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<FilterProducts>(_onFilterProducts);
    on<SortProducts>(_onSortProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(ProductsLoading());
      // TODO: Implement actual product loading logic
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));
      final mockProducts = [
        const Product(
          id: '1',
          name: 'Smart Watch',
          description: 'A beautiful smart watch',
          price: 199.99,
          imageUrl: 'assets/images/watch1.png',
          category: 'Watches',
        ),
        const Product(
          id: '2',
          name: 'Wireless Headphones',
          description: 'High-quality wireless headphones',
          price: 149.99,
          imageUrl: 'assets/images/headphone1.png',
          category: 'Headphones',
        ),
      ];
      emit(ProductsLoaded(products: mockProducts));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onFilterProducts(
    FilterProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(ProductsLoading());
        // TODO: Implement actual filtering logic
        await Future.delayed(const Duration(seconds: 1));
        emit(currentState.copyWith(
          currentCategory: event.category,
          currentSearch: event.searchQuery,
        ));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onSortProducts(
    SortProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProductsLoaded) {
        emit(ProductsLoading());
        // TODO: Implement actual sorting logic
        await Future.delayed(const Duration(seconds: 1));
        emit(currentState.copyWith(currentSort: event.sortBy));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(ProductsLoading());
      // TODO: Implement actual product details loading logic
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));
      final mockProduct = Product(
        id: event.productId,
        name: 'Smart Watch',
        description: 'A beautiful smart watch with advanced features',
        price: 199.99,
        imageUrl: 'assets/images/watch1.png',
        category: 'Watches',
      );
      emit(ProductDetailsLoaded(mockProduct));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}

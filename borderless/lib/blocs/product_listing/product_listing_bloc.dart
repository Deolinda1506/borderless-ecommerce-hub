import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import 'product_listing_event.dart';
import 'product_listing_state.dart';

class ProductListingBloc
    extends Bloc<ProductListingEvent, ProductListingState> {
  ProductListingBloc() : super(const ProductListingState()) {
    on<LoadProducts>(_onLoadProducts);
    on<SortProducts>(_onSortProducts);
    on<FilterProducts>(_onFilterProducts);
    on<SearchProducts>(_onSearchProducts);
    on<ClearFilters>(_onClearFilters);
  }

  // Sample products database
  final List<Product> _allProducts = [
    const Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'High-quality wireless headphones with noise cancellation',
      price: 199.99,
      imageUrl: 'assets/images/headphones.jpg',
      category: 'Electronics',
      colors: [Colors.black, Colors.white],
      sizes: ['One Size'],
      rating: 4.5,
      reviews: 128,
      discountPercentage: 15,
    ),
    const Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Fitness tracking smartwatch with heart rate monitoring',
      price: 299.99,
      imageUrl: 'assets/images/smartwatch.jpg',
      category: 'Electronics',
      colors: [Colors.black, Colors.grey],
      sizes: ['One Size'],
      rating: 4.8,
      reviews: 256,
      discountPercentage: 20,
    ),
    const Product(
      id: '3',
      name: 'Designer Handbag',
      description: 'Luxury leather handbag with gold hardware',
      price: 599.99,
      imageUrl: 'assets/images/handbag.jpg',
      category: 'Fashion',
      colors: [Colors.brown, Colors.black],
      sizes: ['One Size'],
      rating: 4.7,
      reviews: 89,
      discountPercentage: 10,
    ),
    const Product(
      id: '4',
      name: 'Modern Coffee Table',
      description: 'Contemporary glass and wood coffee table',
      price: 399.99,
      imageUrl: 'assets/images/coffee_table.jpg',
      category: 'Furniture',
      colors: [Colors.brown],
      sizes: ['Standard'],
      rating: 4.6,
      reviews: 45,
    ),
    const Product(
      id: '5',
      name: 'Industrial Tool Set',
      description: 'Professional-grade industrial tool set',
      price: 799.99,
      imageUrl: 'assets/images/tool_set.jpg',
      category: 'Industrial',
      colors: [Colors.grey],
      sizes: ['Standard'],
      rating: 4.9,
      reviews: 67,
      discountPercentage: 5,
    ),
    const Product(
      id: '6',
      name: 'Decorative Vase',
      description: 'Handcrafted ceramic decorative vase',
      price: 79.99,
      imageUrl: 'assets/images/vase.jpg',
      category: 'Home Decor',
      colors: [Colors.blue, Colors.white],
      sizes: ['Medium', 'Large'],
      rating: 4.4,
      reviews: 34,
    ),
  ];

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductListingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Filter products by category if specified
      final List<Product> categoryProducts;
      if (event.categoryId == 'all') {
        categoryProducts = List.from(_allProducts);
      } else {
        categoryProducts = _allProducts
            .where((product) =>
                product.category.toLowerCase() ==
                _getCategoryName(event.categoryId).toLowerCase())
            .toList();
      }

      emit(state.copyWith(
        products: categoryProducts,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  String _getCategoryName(String categoryId) {
    switch (categoryId) {
      case '1':
        return 'Electronics';
      case '2':
        return 'Fashion';
      case '3':
        return 'Furniture';
      case '4':
        return 'Industrial';
      case '5':
        return 'Home Decor';
      case '6':
        return 'Electronics';
      case '7':
        return 'Construction & Real Estate';
      case '8':
        return 'Fabrication Service';
      case '9':
        return 'Electrical Equipment';
      default:
        return '';
    }
  }

  void _onSortProducts(SortProducts event, Emitter<ProductListingState> emit) {
    final sortedProducts = List<Product>.from(state.products);

    switch (event.sortBy) {
      case 'price_low':
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        sortedProducts.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'popular':
        sortedProducts
            .sort((a, b) => (b.reviews ?? 0).compareTo(a.reviews ?? 0));
        break;
    }

    emit(state.copyWith(
      products: sortedProducts,
      sortBy: event.sortBy,
    ));
  }

  void _onFilterProducts(
      FilterProducts event, Emitter<ProductListingState> emit) {
    final filteredProducts = List<Product>.from(state.products);

    // Apply filters
    if (event.filters.containsKey('price_range')) {
      final range = event.filters['price_range'] as List<double>;
      filteredProducts.removeWhere(
        (product) => product.price < range[0] || product.price > range[1],
      );
    }

    if (event.filters.containsKey('rating')) {
      final minRating = event.filters['rating'] as double;
      filteredProducts.removeWhere(
        (product) => (product.rating ?? 0) < minRating,
      );
    }

    if (event.filters.containsKey('colors')) {
      final colors = event.filters['colors'] as List<Color>;
      filteredProducts.removeWhere(
        (product) =>
            product.colors == null ||
            !product.colors!.any((color) => colors.contains(color)),
      );
    }

    emit(state.copyWith(
      products: filteredProducts,
      filters: event.filters,
    ));
  }

  void _onSearchProducts(
      SearchProducts event, Emitter<ProductListingState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        searchQuery: '',
        products: state.products,
      ));
      return;
    }

    final searchResults = state.products.where((product) {
      return product.name.toLowerCase().contains(event.query.toLowerCase()) ||
          product.description.toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(state.copyWith(
      products: searchResults,
      searchQuery: event.query,
    ));
  }

  void _onClearFilters(ClearFilters event, Emitter<ProductListingState> emit) {
    emit(state.copyWith(
      filters: const {},
      products: state.products,
    ));
  }
}

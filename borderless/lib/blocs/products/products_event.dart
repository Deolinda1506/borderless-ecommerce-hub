import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {}

class FilterProducts extends ProductsEvent {
  final String category;
  final double? minPrice;
  final double? maxPrice;
  final String? searchQuery;

  const FilterProducts({
    this.category = '',
    this.minPrice,
    this.maxPrice,
    this.searchQuery,
  });

  @override
  List<Object> get props => [
        category,
        minPrice ?? 0.0,
        maxPrice ?? 0.0,
        searchQuery ?? '',
      ];
}

class SortProducts extends ProductsEvent {
  final String sortBy; // 'price_asc', 'price_desc', 'name_asc', 'name_desc'

  const SortProducts(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}

class LoadProductDetails extends ProductsEvent {
  final String productId;

  const LoadProductDetails(this.productId);

  @override
  List<Object> get props => [productId];
}

import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final Product product;

  const AddToWishlist(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromWishlist extends WishlistEvent {
  final String productId;

  const RemoveFromWishlist(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearWishlist extends WishlistEvent {}

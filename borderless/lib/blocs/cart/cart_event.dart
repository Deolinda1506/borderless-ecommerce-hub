import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;
  final String selectedSize;
  final Color? selectedColor;
  final String imageUrl;

  const AddToCart({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    this.selectedColor,
    required this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [product, quantity, selectedSize, selectedColor, imageUrl];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class SaveForLater extends CartEvent {
  final String productId;

  const SaveForLater(this.productId);

  @override
  List<Object?> get props => [productId];
}

class MoveToCart extends CartEvent {
  final String productId;

  const MoveToCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RemoveSavedItem extends CartEvent {
  final String productId;

  const RemoveSavedItem(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {}

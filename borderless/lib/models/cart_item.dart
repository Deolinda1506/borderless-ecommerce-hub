import 'package:flutter/material.dart';
import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final Color? selectedColor;
  final String? selectedSize;
  bool isSavedForLater;

  CartItem({
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.isSavedForLater = false,
  });

  String get imageUrl => product.imageUrl;
  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    Color? selectedColor,
    String? selectedSize,
    bool? isSavedForLater,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      isSavedForLater: isSavedForLater ?? this.isSavedForLater,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor?.value,
      'isSavedForLater': isSavedForLater,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      selectedSize: json['selectedSize'],
      selectedColor:
          json['selectedColor'] != null ? Color(json['selectedColor']) : null,
      isSavedForLater: json['isSavedForLater'] ?? false,
    );
  }
}

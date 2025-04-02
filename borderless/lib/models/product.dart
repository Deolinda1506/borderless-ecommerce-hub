import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final String category;
  final List<Color>? colors;
  final bool isAvailable;
  final bool isFavorite;
  final double? discountPercentage;
  final List<String>? sizes;
  final double? rating;
  final int? reviews;
  final bool isNew;
  final List<Map<String, dynamic>>? products;
  final List<String>? specifications;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.category,
    this.colors,
    this.isAvailable = true,
    this.isFavorite = false,
    this.discountPercentage,
    this.sizes,
    this.rating,
    this.reviews,
    this.isNew = false,
    this.products,
    this.specifications,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        oldPrice,
        imageUrl,
        category,
        colors,
        isAvailable,
        isFavorite,
        discountPercentage,
        sizes,
        rating,
        reviews,
        isNew,
        products,
        specifications,
      ];

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? oldPrice,
    String? imageUrl,
    String? category,
    List<Color>? colors,
    bool? isAvailable,
    bool? isFavorite,
    double? discountPercentage,
    List<String>? sizes,
    double? rating,
    int? reviews,
    bool? isNew,
    List<Map<String, dynamic>>? products,
    List<String>? specifications,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      sizes: sizes ?? this.sizes,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      isNew: isNew ?? this.isNew,
      products: products ?? this.products,
      specifications: specifications ?? this.specifications,
    );
  }

  double get discountedPrice {
    if (discountPercentage == null) return price;
    return price * (1 - discountPercentage! / 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'imageUrl': imageUrl,
      'category': category,
      'colors': colors?.map((color) => color.value).toList(),
      'isAvailable': isAvailable,
      'isFavorite': isFavorite,
      'discountPercentage': discountPercentage,
      'sizes': sizes,
      'rating': rating,
      'reviews': reviews,
      'isNew': isNew,
      'products': products,
      'specifications': specifications,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      colors: json['colors'] != null
          ? (json['colors'] as List)
              .map((colorValue) => Color(colorValue))
              .toList()
          : null,
      isAvailable: json['isAvailable'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      discountPercentage: json['discountPercentage']?.toDouble(),
      sizes: json['sizes']?.cast<String>(),
      rating: json['rating']?.toDouble(),
      reviews: json['reviews'],
      isNew: json['isNew'] ?? false,
      products: json['products']?.cast<Map<String, dynamic>>(),
      specifications: json['specifications']?.cast<String>(),
    );
  }
}

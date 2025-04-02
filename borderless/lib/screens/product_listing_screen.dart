import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_listing/product_listing_bloc.dart';
import '../blocs/product_listing/product_listing_event.dart';
import '../blocs/product_listing/product_listing_state.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../blocs/wishlist/wishlist_bloc.dart' as wishlist_bloc;
import '../blocs/wishlist/wishlist_state.dart';
import '../blocs/wishlist/wishlist_event.dart' as wishlist_event;

class ProductListingScreen extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final String title;
  final List<Map<String, dynamic>> products;

  const ProductListingScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.title,
    required this.products,
  });

  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    category: widget.categoryId,
                    subcategory: widget.subcategoryId,
                    item: product['name'],
                    imageUrl: product['image'],
                    price: product['price'].toDouble(),
                    discountPercentage: product['oldPrice'] != null
                        ? ((product['oldPrice'] - product['price']) /
                                product['oldPrice'] *
                                100)
                            .roundToDouble()
                        : null,
                    description: product['description'],
                  ),
                ),
              );
            },
            child: _buildProductCard(product),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _applyFilter(
      List<Map<String, dynamic>> products, String filter) {
    List<Map<String, dynamic>> sortedList = List.from(products);
    switch (filter) {
      case 'Price (Low to High)':
        sortedList.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price (High to Low)':
        sortedList.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'A - Z':
        sortedList.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Z - A':
        sortedList.sort((a, b) => b['name'].compareTo(a['name']));
        break;
    }
    return sortedList;
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.asset(
                product['image'],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product['price']}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product['oldPrice'] != null)
                      Text(
                        "\$${product['oldPrice']}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product['description'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: BlocBuilder<wishlist_bloc.WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      final isWishlisted = state.items
                              ?.any((item) => item.name == product['name']) ??
                          false;
                      return IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : null,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (isWishlisted) {
                            final wishlistProduct = state.items?.firstWhere(
                                (item) => item.name == product['name']);
                            if (wishlistProduct != null) {
                              context.read<wishlist_bloc.WishlistBloc>().add(
                                  wishlist_event.RemoveFromWishlist(
                                      wishlistProduct.id));
                            }
                          } else {
                            final newProduct = Product(
                              id: DateTime.now().toString(),
                              name: product['name'],
                              description: product['description'],
                              price: product['price'],
                              oldPrice: product['oldPrice'],
                              imageUrl: product['image'],
                              category: widget.categoryId,
                              colors: const [Colors.black],
                            );
                            context
                                .read<wishlist_bloc.WishlistBloc>()
                                .add(wishlist_event.AddToWishlist(newProduct));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

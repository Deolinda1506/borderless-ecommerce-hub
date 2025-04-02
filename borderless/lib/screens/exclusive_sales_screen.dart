import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/filter_bottom_sheet.dart';

class ExclusiveSalesScreen extends StatelessWidget {
  const ExclusiveSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      const Product(
        id: '1',
        name: 'Loop silicone strong',
        price: 15.25,
        oldPrice: 40.00,
        imageUrl: 'assets/images/headphones1.png',
        description: 'Loop silicone strong band',
        category: 'Headphones',
        colors: [Colors.blue, Colors.green, Colors.purple],
      ),
      const Product(
        id: '2',
        name: 'K800 Ultra smart watch',
        price: 32.00,
        oldPrice: 35.00,
        imageUrl: 'assets/images/headphones2.png',
        description: 'K800 Ultra smart watch',
        category: 'Headphones',
        colors: [Colors.black, Colors.grey, Colors.blue],
      ),
      const Product(
        id: '3',
        name: 'P47 Wireless headphones',
        price: 35.45,
        oldPrice: 45.00,
        imageUrl: 'assets/images/headphones3.png',
        description: 'P47 Wireless headphones',
        category: 'Headphones',
        colors: [Colors.blue, Colors.red, Colors.black],
      ),
      const Product(
        id: '4',
        name: 'M6 IP67 headphones',
        price: 12.00,
        oldPrice: 18.00,
        imageUrl: 'assets/images/headphones4.png',
        description: 'M6 IP67 headphones',
        category: 'Headphones',
        colors: [Colors.orange, Colors.grey, Colors.black],
      ),
      const Product(
        id: '5',
        name: 'D20 bluetooth smart h...',
        price: 25.25,
        oldPrice: 30.00,
        imageUrl: 'assets/images/headphones5.png',
        description: 'D20 bluetooth smart headphones',
        category: 'Headphones',
        colors: [Colors.blue, Colors.purple],
      ),
      const Product(
        id: '6',
        name: 'D18s Smart headphones',
        price: 17.15,
        oldPrice: 22.00,
        imageUrl: 'assets/images/headphones6.png',
        description: 'D18s Smart headphones',
        category: 'Headphones',
        colors: [Colors.blue, Colors.black],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              leading: ScaleOnTap(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              title: const Text(
                'Exclusive Sale',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.black),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FilterBottomSheet(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    // Navigate to search screen
                  },
                ),
              ],
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to product details
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    product.imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: product.colors?.map((color) {
                                  return Container(
                                    width: 16,
                                    height: 16,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF21D4B4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${product.oldPrice?.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

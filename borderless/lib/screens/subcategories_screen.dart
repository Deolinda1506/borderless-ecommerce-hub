import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borderless/screens/product_listing_screen.dart';
import 'package:borderless/screens/wishlist_screen.dart';
import 'package:borderless/models/product.dart';
import 'package:borderless/blocs/products/products_bloc.dart';
import 'package:borderless/blocs/products/products_event.dart';
import 'package:borderless/blocs/products/products_state.dart';

class SubcategoriesScreen extends StatelessWidget {
  final String category;

  const SubcategoriesScreen({Key? key, required this.category})
      : super(key: key);

  List<Product> getSubcategoriesForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return [
          Product(
            id: 'electronics_smartphones',
            name: 'Smartphones',
            description: 'Latest smartphones and accessories',
            price: 999.99,
            imageUrl: 'assets/images/subcategories/smartphone.png',
            category: category,
            products: const [
              {
                'name': "iPhone 15 Pro Max",
                'price': 1199.99,
                'oldPrice': 1299.99,
                'image': 'assets/images/products/iphone15.png',
                'description': 'Latest iPhone with advanced features',
                'specs': const ['6.7" Display', 'A17 Pro Chip', '48MP Camera'],
              },
              {
                'name': "Samsung Galaxy S24",
                'price': 999.99,
                'oldPrice': 1099.99,
                'image': 'assets/images/products/samsung_s24.png',
                'description': 'Flagship Android smartphone',
                'specs': const [
                  '6.8" Display',
                  'Snapdragon 8 Gen 3',
                  '200MP Camera'
                ],
              },
            ],
          ),
        ];
      case 'fashion':
        return [
          Product(
            id: 'fashion_clothing',
            name: 'Clothing',
            description: 'Men, women, and kids clothing',
            price: 49.99,
            imageUrl: 'assets/images/subcategories/clothing.png',
            category: category,
            products: const [
              {
                'name': "Classic Denim Jacket",
                'price': 79.99,
                'oldPrice': 99.99,
                'image': 'assets/images/products/denim_jacket.png',
                'description': 'Timeless denim jacket for all occasions',
                'specs': const [
                  '100% Cotton',
                  'Classic Fit',
                  'Multiple Colors'
                ],
              },
              {
                'name': "Casual T-Shirt",
                'price': 29.99,
                'oldPrice': 39.99,
                'image': 'assets/images/products/tshirt.png',
                'description': 'Comfortable everyday t-shirt',
                'specs': const ['Cotton Blend', 'Regular Fit', 'Various Sizes'],
              },
            ],
          ),
        ];
      case 'furniture':
        return [
          Product(
            id: 'furniture_living',
            name: 'Living Room',
            description: 'Sofas, tables, and storage',
            price: 799.99,
            imageUrl: 'assets/images/subcategories/sofa.png',
            category: category,
            products: const [
              {
                'name': "Modern 3-Seater Sofa",
                'price': 899.99,
                'oldPrice': 1099.99,
                'image': 'assets/images/products/sofa.png',
                'description':
                    'Contemporary design sofa with premium materials',
                'specs': const ['Premium Leather', '3-Seater', 'Reclining'],
              },
              {
                'name': "Coffee Table",
                'price': 299.99,
                'oldPrice': 399.99,
                'image': 'assets/images/products/coffee_table.png',
                'description': 'Stylish coffee table with storage',
                'specs': const ['Solid Wood', 'Storage Space', 'Modern Design'],
              },
            ],
          ),
        ];
      case 'industrial':
        return [
          Product(
            id: 'industrial_machinery',
            name: 'Machinery',
            description: 'Heavy equipment and tools',
            price: 9999.99,
            imageUrl: 'assets/images/subcategories/machinery.png',
            category: category,
            products: const [
              {
                'name': "Industrial Drill Press",
                'price': 1299.99,
                'oldPrice': 1499.99,
                'image': 'assets/images/products/drill_press.png',
                'description': 'Professional grade drill press',
                'specs': const [
                  'Variable Speed',
                  'Digital Display',
                  'Safety Features'
                ],
              },
              {
                'name': "Heavy Duty Lathe",
                'price': 4999.99,
                'oldPrice': 5999.99,
                'image': 'assets/images/products/lathe.png',
                'description': 'Precision metalworking lathe',
                'specs': const [
                  'CNC Control',
                  'Large Work Area',
                  'Coolant System'
                ],
              },
            ],
          ),
        ];
      case 'home decor':
        return [
          Product(
            id: 'home_decor_lighting',
            name: 'Lighting',
            description: 'Chandeliers, lamps, and bulbs',
            price: 199.99,
            imageUrl: 'assets/images/subcategories/lighting.png',
            category: category,
            products: const [
              {
                'name': "Crystal Chandelier",
                'price': 299.99,
                'oldPrice': 399.99,
                'image': 'assets/images/products/chandelier.png',
                'description': 'Elegant crystal chandelier',
                'specs': const ['LED Bulbs', 'Remote Control', 'Dimmable'],
              },
              {
                'name': "Modern Floor Lamp",
                'price': 149.99,
                'oldPrice': 199.99,
                'image': 'assets/images/products/floor_lamp.png',
                'description': 'Contemporary floor lamp',
                'specs': const [
                  'Adjustable Height',
                  'Smart Control',
                  'Energy Efficient'
                ],
              },
            ],
          ),
        ];
      case 'construction & real estate':
        return [
          Product(
            id: 'construction_materials',
            name: 'Materials',
            description: 'Concrete, steel, and timber',
            price: 599.99,
            imageUrl: 'assets/images/subcategories/concrete.png',
            category: category,
            products: const [
              {
                'name': "High-Strength Concrete",
                'price': 89.99,
                'oldPrice': 99.99,
                'image': 'assets/images/products/concrete_mix.png',
                'description': 'Premium concrete mix for construction',
                'specs': const [
                  '40MPa Strength',
                  'Fast Setting',
                  'Weather Resistant'
                ],
              },
              {
                'name': "Structural Steel Beams",
                'price': 299.99,
                'oldPrice': 399.99,
                'image': 'assets/images/products/steel_beams.png',
                'description': 'Heavy-duty structural steel',
                'specs': const [
                  'Grade A Steel',
                  'Various Sizes',
                  'Corrosion Resistant'
                ],
              },
            ],
          ),
        ];
      case 'electrical equipment':
        return [
          Product(
            id: 'electrical_components',
            name: 'Components',
            description: 'Wiring and circuit breakers',
            price: 49.99,
            imageUrl: 'assets/images/subcategories/wiring.png',
            category: category,
            products: const [
              {
                'name': "Circuit Breaker Panel",
                'price': 199.99,
                'oldPrice': 249.99,
                'image': 'assets/images/products/circuit_breaker.png',
                'description': 'Main circuit breaker panel',
                'specs': const [
                  '200A Capacity',
                  'Surge Protection',
                  'Safety Rated'
                ],
              },
              {
                'name': "Copper Wiring Kit",
                'price': 79.99,
                'oldPrice': 99.99,
                'image': 'assets/images/products/wiring_kit.png',
                'description': 'Complete electrical wiring kit',
                'specs': const ['12 Gauge', '100m Length', 'Color Coded'],
              },
            ],
          ),
        ];
      case 'fabrication service':
        return [
          Product(
            id: 'fabrication_metal',
            name: 'Metal Work',
            description: 'Steel and aluminum fabrication',
            price: 799.99,
            imageUrl: 'assets/images/subcategories/steel.png',
            category: category,
            products: const [
              {
                'name': "Metal Cutting Saw",
                'price': 599.99,
                'oldPrice': 699.99,
                'image': 'assets/images/products/metal_saw.png',
                'description': 'Professional metal cutting saw',
                'specs': const [
                  'Variable Speed',
                  'Coolant System',
                  'Precision Guide'
                ],
              },
              {
                'name': "Welding Machine",
                'price': 899.99,
                'oldPrice': 1099.99,
                'image': 'assets/images/products/welding_machine.png',
                'description': 'Industrial welding machine',
                'specs': const [
                  'MIG/TIG Capable',
                  'Digital Control',
                  'Safety Features'
                ],
              },
            ],
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final subcategories = getSubcategoriesForCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final product = subcategories[index];

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListingScreen(
                      categoryId: category,
                      subcategoryId: product.id,
                      title: product.name,
                      products: product.products ?? [],
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
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
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

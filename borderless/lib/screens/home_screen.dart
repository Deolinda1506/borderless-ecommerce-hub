import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_widgets.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import 'categories_screen.dart';
import 'product_listing_screen.dart';
import 'search_screen.dart';
import 'exclusive_sales_screen.dart';
import 'auth/sign_up_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'profile/profile_screen.dart';
import '../widgets/logo.dart';
import 'product_detail_screen.dart';
import 'subcategories_screen.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../blocs/wishlist/wishlist_event.dart';
import '../blocs/wishlist/wishlist_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;

  final List<Map<String, String>> _banners = [
    {
      'image': 'assets/images/banner.png',
      'title': 'Exclusive Sales',
      'subtitle': '30% OFF on headphones',
    },
    {
      'image': 'assets/images/banner.png',
      'title': 'New Collection',
      'subtitle': 'Smart Watches & Accessories',
    },
  ];

  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Electronics',
      imageUrl: 'assets/icons/electronics.png',
      subCategories: [
        SubCategory(
            id: '1_1',
            name: 'Smartphones',
            image: 'assets/icons/electronics.png'),
        SubCategory(
            id: '1_2', name: 'Laptops', image: 'assets/icons/electronics.png'),
        SubCategory(
            id: '1_3', name: 'Tablets', image: 'assets/icons/electronics.png'),
        SubCategory(
            id: '1_4',
            name: 'Accessories',
            image: 'assets/icons/electronics.png'),
        SubCategory(
            id: '1_5',
            name: 'Smart Watches',
            image: 'assets/icons/electronics.png'),
        SubCategory(
            id: '1_6',
            name: 'Audio Devices',
            image: 'assets/icons/electronics.png'),
      ],
    ),
    Category(
      id: '2',
      name: 'Fashion',
      imageUrl: 'assets/icons/fashion.png',
      subCategories: [
        SubCategory(
            id: '2_1',
            name: 'Men\'s Clothing',
            image: 'assets/icons/fashion.png'),
        SubCategory(
            id: '2_2',
            name: 'Women\'s Clothing',
            image: 'assets/icons/fashion.png'),
        SubCategory(
            id: '2_3', name: 'Shoes', image: 'assets/icons/fashion.png'),
        SubCategory(
            id: '2_4', name: 'Accessories', image: 'assets/icons/fashion.png'),
        SubCategory(
            id: '2_5', name: 'Jewelry', image: 'assets/icons/fashion.png'),
        SubCategory(id: '2_6', name: 'Bags', image: 'assets/icons/fashion.png'),
      ],
    ),
    Category(
      id: '3',
      name: 'Furniture',
      imageUrl: 'assets/icons/furniture.png',
      subCategories: [
        SubCategory(
            id: '3_1',
            name: 'Living Room',
            image: 'assets/icons/furniture.png'),
        SubCategory(
            id: '3_2', name: 'Bedroom', image: 'assets/icons/furniture.png'),
        SubCategory(
            id: '3_3', name: 'Kitchen', image: 'assets/icons/furniture.png'),
        SubCategory(
            id: '3_4', name: 'Office', image: 'assets/icons/furniture.png'),
        SubCategory(
            id: '3_5', name: 'Outdoor', image: 'assets/icons/furniture.png'),
        SubCategory(
            id: '3_6', name: 'Storage', image: 'assets/icons/furniture.png'),
      ],
    ),
    Category(
      id: '4',
      name: 'Industrial',
      imageUrl: 'assets/icons/industrial.png',
      subCategories: [
        SubCategory(
            id: '4_1', name: 'Machinery', image: 'assets/icons/industrial.png'),
        SubCategory(
            id: '4_2', name: 'Tools', image: 'assets/icons/industrial.png'),
        SubCategory(
            id: '4_3',
            name: 'Safety Equipment',
            image: 'assets/icons/industrial.png'),
        SubCategory(
            id: '4_4', name: 'Workwear', image: 'assets/icons/industrial.png'),
        SubCategory(
            id: '4_5',
            name: 'Industrial Supplies',
            image: 'assets/icons/industrial.png'),
        SubCategory(
            id: '4_6',
            name: 'Heavy Equipment',
            image: 'assets/icons/industrial.png'),
      ],
    ),
    Category(
      id: '5',
      name: 'Home Decor',
      imageUrl: 'assets/icons/home_decor.png',
      subCategories: [
        SubCategory(
            id: '5_1', name: 'Lighting', image: 'assets/icons/home_decor.png'),
        SubCategory(
            id: '5_2', name: 'Wall Art', image: 'assets/icons/home_decor.png'),
        SubCategory(
            id: '5_3', name: 'Rugs', image: 'assets/icons/home_decor.png'),
        SubCategory(
            id: '5_4', name: 'Curtains', image: 'assets/icons/home_decor.png'),
        SubCategory(
            id: '5_5',
            name: 'Decorative Items',
            image: 'assets/icons/home_decor.png'),
        SubCategory(
            id: '5_6', name: 'Plants', image: 'assets/icons/home_decor.png'),
      ],
    ),
    Category(
      id: '7',
      name: 'Construction & Real Estate',
      imageUrl: 'assets/icons/construction.png',
      subCategories: [
        SubCategory(
            id: '7_1',
            name: 'Building Materials',
            image: 'assets/icons/construction.png'),
        SubCategory(
            id: '7_2',
            name: 'Construction Tools',
            image: 'assets/icons/construction.png'),
        SubCategory(
            id: '7_3',
            name: 'Real Estate Listings',
            image: 'assets/icons/construction.png'),
        SubCategory(
            id: '7_4',
            name: 'Property Services',
            image: 'assets/icons/construction.png'),
        SubCategory(
            id: '7_5',
            name: 'Contractors',
            image: 'assets/icons/construction.png'),
        SubCategory(
            id: '7_6',
            name: 'Architecture Services',
            image: 'assets/icons/construction.png'),
      ],
    ),
    Category(
      id: '8',
      name: 'Fabrication Service',
      imageUrl: 'assets/icons/fabrication.png',
      subCategories: [
        SubCategory(
            id: '8_1',
            name: 'Metal Fabrication',
            image: 'assets/icons/fabrication.png'),
        SubCategory(
            id: '8_2',
            name: 'Woodworking',
            image: 'assets/icons/fabrication.png'),
        SubCategory(
            id: '8_3',
            name: 'Plastic Fabrication',
            image: 'assets/icons/fabrication.png'),
        SubCategory(
            id: '8_4',
            name: 'Custom Projects',
            image: 'assets/icons/fabrication.png'),
        SubCategory(
            id: '8_5',
            name: 'Repair Services',
            image: 'assets/icons/fabrication.png'),
        SubCategory(
            id: '8_6',
            name: 'Installation',
            image: 'assets/icons/fabrication.png'),
      ],
    ),
    Category(
      id: '9',
      name: 'Electrical Equipment',
      imageUrl: 'assets/icons/electrical_equipment.png',
      subCategories: [
        SubCategory(
            id: '9_1',
            name: 'Power Tools',
            image: 'assets/icons/electrical_equipment.png'),
        SubCategory(
            id: '9_2',
            name: 'Electrical Supplies',
            image: 'assets/icons/electrical_equipment.png'),
        SubCategory(
            id: '9_3',
            name: 'Lighting Equipment',
            image: 'assets/icons/electrical_equipment.png'),
        SubCategory(
            id: '9_4',
            name: 'Safety Gear',
            image: 'assets/icons/electrical_equipment.png'),
        SubCategory(
            id: '9_5',
            name: 'Testing Equipment',
            image: 'assets/icons/electrical_equipment.png'),
        SubCategory(
            id: '9_6',
            name: 'Installation Tools',
            image: 'assets/icons/electrical_equipment.png'),
      ],
    ),
  ];

  final List<Product> _latestProducts = [
    Product(
      id: '1',
      name: 'Nike air Jordan retro fa...',
      price: 126.00,
      imageUrl: 'assets/images/nike_shoes.png',
      description:
          'Classic Nike Air Jordan Retro sneakers featuring premium leather upper, Air cushioning technology, and iconic design elements. Perfect for both style and comfort.',
      category: 'Fashion',
      colors: [
        const Color(0xFF1E1E1E),
        const Color(0xFFD32F2F),
        const Color(0xFF4CAF50)
      ],
      discountPercentage: 30,
      specifications: [
        'Premium leather upper',
        'Air cushioning technology',
        'Rubber outsole',
        'Available in multiple colors',
        'True to size fit'
      ],
    ),
    Product(
      id: '2',
      name: 'Classic new black glas...',
      price: 8.50,
      imageUrl: 'assets/images/glasses.png',
      description:
          'Stylish and comfortable black glasses with modern design. Features UV protection, lightweight frame, and perfect for everyday wear.',
      category: 'Fashion',
      colors: [
        const Color(0xFF1E1E1E),
        const Color(0xFF795548),
        const Color(0xFF9E9E9E)
      ],
      specifications: [
        'UV protection lenses',
        'Lightweight frame',
        'Adjustable nose pads',
        'Spring hinges',
        'Comes with protective case'
      ],
    ),
    Product(
      id: '3',
      name: 'Apple Watch Series 8',
      price: 399.00,
      imageUrl: 'assets/images/smartwatch.png',
      description:
          'Latest Apple Watch with advanced health features including heart rate monitoring, ECG, blood oxygen tracking, and always-on display. Water resistant and perfect for fitness enthusiasts.',
      category: 'Electronics',
      colors: [
        const Color(0xFF1E1E1E),
        const Color(0xFFE0E0E0),
        const Color(0xFFFFA000)
      ],
      discountPercentage: 15,
      specifications: [
        'Always-on display',
        'Heart rate monitoring',
        'ECG capability',
        'Blood oxygen tracking',
        'Water resistant',
        'GPS enabled'
      ],
    ),
    Product(
      id: '4',
      name: 'Modern Leather Backpack',
      price: 89.99,
      imageUrl: 'assets/images/backpack.png',
      description:
          'Premium leather backpack with dedicated laptop compartment, multiple pockets, and adjustable straps. Perfect for daily commute and travel.',
      category: 'Fashion',
      colors: [
        const Color(0xFF795548),
        const Color(0xFF1E1E1E),
        const Color(0xFFD7CCC8)
      ],
      discountPercentage: 20,
      specifications: [
        'Genuine leather',
        'Laptop compartment',
        'Water resistant',
        'Multiple pockets',
        'Adjustable straps',
        'Anti-theft design'
      ],
    ),
    Product(
      id: '5',
      name: 'Wireless Earbuds Pro',
      price: 149.99,
      imageUrl: 'assets/images/earbuds.png',
      description:
          'High-quality wireless earbuds with active noise cancellation, 24-hour battery life, and crystal-clear sound quality. Perfect for music lovers and professionals.',
      category: 'Electronics',
      colors: [const Color(0xFF1E1E1E), const Color(0xFFFFFFFF)],
      discountPercentage: 25,
      specifications: [
        'Active noise cancellation',
        '24-hour battery life',
        'Touch controls',
        'Voice assistant support',
        'Water resistant',
        'Bluetooth 5.0'
      ],
    ),
    Product(
      id: '6',
      name: 'Designer Crossbody Bag',
      price: 199.99,
      imageUrl: 'assets/images/handbag.png',
      description:
          'Elegant designer crossbody bag crafted from premium materials. Features adjustable strap, multiple compartments, and secure closure. Ideal for everyday use.',
      category: 'Fashion',
      colors: [
        const Color(0xFFD7CCC8),
        const Color(0xFF1E1E1E),
        const Color(0xFFD32F2F)
      ],
      discountPercentage: 30,
      specifications: [
        'Premium materials',
        'Adjustable strap',
        'Multiple compartments',
        'Secure closure',
        'Inner pockets',
        'Water resistant'
      ],
    ),
  ];

  Map<String, bool> _favoriteStates = {};

  @override
  void initState() {
    super.initState();
    // Initialize favorite states
    for (var product in _latestProducts) {
      _favoriteStates[product.id] = product.isFavorite;
    }
  }

  void _toggleFavorite(String productId) {
    setState(() {
      _favoriteStates[productId] = !(_favoriteStates[productId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Logo(size: 28),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      Text(
                        'Search products...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Banner Section
            AspectRatio(
              aspectRatio: 1.5,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: _banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBanner = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ExclusiveSalesScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(banner['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  banner['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  banner['subtitle']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Row(
                      children: List.generate(
                        _banners.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentBanner == index
                                ? const Color(0xFF21D4B4)
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategoriesScreen()),
                          );
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubcategoriesScreen(
                                  category: category.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  category.imageUrl,
                                  width: 48,
                                  height: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Latest Products Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latest Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListingScreen(
                                categoryId: 'all',
                                subcategoryId: '',
                                title: 'Latest Products',
                                products: _latestProducts
                                    .map((product) => {
                                          'name': product.name,
                                          'price': product.price,
                                          'oldPrice': product.oldPrice,
                                          'image': product.imageUrl,
                                          'description': product.description,
                                          'specs': product.specifications,
                                        })
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _latestProducts.length,
                    itemBuilder: (context, index) {
                      final product = _latestProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                category: product.category,
                                subcategory: '',
                                item: product.name,
                                imageUrl: product.imageUrl,
                                price: product.price,
                                colors: product.colors,
                                description: product.description,
                              ),
                            ),
                          );
                        },
                        child: _buildProductCard(product),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      final isWishlisted =
                          state.items?.any((item) => item.id == product.id) ??
                              false;
                      return IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          if (isWishlisted) {
                            final wishlistProduct = state.items
                                ?.firstWhere((item) => item.id == product.id);
                            if (wishlistProduct != null) {
                              context
                                  .read<WishlistBloc>()
                                  .add(RemoveFromWishlist(wishlistProduct.id));
                            }
                          } else {
                            context
                                .read<WishlistBloc>()
                                .add(AddToWishlist(product));
                          }
                        },
                      );
                    },
                  ),
                ),
                if (product.discountPercentage != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21D4B4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (product.discountPercentage != null) ...[
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            '\$${(product.price * (1 - (product.discountPercentage ?? 0) / 100)).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF21D4B4),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

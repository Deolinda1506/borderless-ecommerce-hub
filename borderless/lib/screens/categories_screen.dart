import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/bottom_nav_bar.dart';
import 'subcategories_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Category> categories = [
    Category(
      id: '1',
      name: 'Electronics',
      imageUrl: 'assets/icons/electronics.png',
    ),
    Category(
      id: '2',
      name: 'Fashion',
      imageUrl: 'assets/icons/fashion.png',
    ),
    Category(
      id: '3',
      name: 'Furniture',
      imageUrl: 'assets/icons/furniture.png',
    ),
    Category(
      id: '4',
      name: 'Industrial',
      imageUrl: 'assets/icons/industrial.png',
    ),
    Category(
      id: '5',
      name: 'Home Decor',
      imageUrl: 'assets/icons/home_decor.png',
    ),
    Category(
      id: '7',
      name: 'Construction & Real Estate',
      imageUrl: 'assets/icons/construction.png',
    ),
    Category(
      id: '8',
      name: 'Fabrication Service',
      imageUrl: 'assets/icons/fabrication.png',
    ),
    Category(
      id: '9',
      name: 'Electrical Equipment',
      imageUrl: 'assets/icons/electrical_equipment.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        category.imageUrl,
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

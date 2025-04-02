import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'exclusive_sale_screen.dart' as exclusive;
import '../models/product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  String _selectedSort = 'Price (High to Low)';
  bool _showResults = false;

  final List<String> recentSearches = [
    'Smart watch',
    'Laptop',
    'Women bag',
    'Headphones',
    'Shoes',
    'Eye glasses',
  ];

  // Mock search results
  final List<Product> _allProducts = [
    const Product(
      id: '1',
      name: 'Nike Air Max 270',
      description:
          'Experience ultimate comfort with Nike Air Max 270. Features React foam midsole, breathable mesh upper, and the tallest Air unit yet for maximum cushioning. Perfect for both athletic performance and casual wear.',
      price: 150.00,
      imageUrl: 'assets/images/nike_shoes.png',
      category: 'Shoes',
      colors: [Colors.black, Colors.white, Colors.red],
      isAvailable: true,
      rating: 4.5,
      reviews: 128,
    ),
    const Product(
      id: '2',
      name: 'Ray-Ban Sunglasses',
      description:
          'Iconic Ray-Ban Aviator sunglasses with polarized lenses, gold-tone metal frame, and 100% UV protection. Includes premium leather case and cleaning cloth. Made in Italy.',
      price: 199.99,
      imageUrl: 'assets/images/glasses.png',
      category: 'Accessories',
      colors: [Colors.black, Colors.grey],
      isAvailable: true,
      rating: 4.3,
      reviews: 95,
    ),
    const Product(
      id: '3',
      name: 'Smart Watch Pro',
      description:
          'Advanced smartwatch with heart rate monitoring, sleep tracking, and GPS. Features a 1.4" AMOLED display, 5 ATM water resistance, and 7-day battery life. Compatible with iOS and Android.',
      price: 299.99,
      imageUrl: 'assets/images/smartwatch.png',
      category: 'Electronics',
      colors: [Colors.black, Colors.blue],
      isAvailable: true,
      rating: 4.7,
      reviews: 256,
    ),
    const Product(
      id: '4',
      name: 'Laptop Ultra',
      description:
          '15.6" Ultra-thin laptop with 11th Gen Intel Core i7, 16GB RAM, 512GB SSD, and NVIDIA RTX 3050Ti. Features Thunderbolt 4, backlit keyboard, and 12-hour battery life. Perfect for professionals.',
      price: 1299.99,
      imageUrl: 'assets/images/laptop.png',
      category: 'Electronics',
      colors: [Colors.grey, Colors.black],
      isAvailable: true,
      rating: 4.6,
      reviews: 189,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _showResults = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = [];
        return;
      }

      _filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
      }).toList();

      _applySorting();
    });
  }

  void _applySorting() {
    switch (_selectedSort) {
      case 'Price (Low to High)':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price (High to Low)':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'A-Z':
        _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Z-A':
        _filteredProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedSort: _selectedSort,
        onSortChanged: (String newSort) {
          setState(() {
            _selectedSort = newSort;
            _applySorting();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _navigateToExclusiveSale() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const exclusive.ExclusiveSaleScreen(),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              product.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21D4B4),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[700],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' (${product.reviews})',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/filter.svg',
              width: 24,
              height: 24,
            ),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF21D4B4)),
                ),
              ),
            ),
          ),
          if (_showResults) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${_filteredProducts.length} results found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(_filteredProducts[index]);
                },
              ),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'RECENT SEARCH',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return _buildRecentSearchItem(recentSearches[index]);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String search) {
    return InkWell(
      onTap: () {
        _searchController.text = search;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.history,
              color: Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                search,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final String selectedSort;
  final Function(String) onSortChanged;

  const FilterBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedSort;
  final List<String> _sortOptions = [
    'Price (Low to High)',
    'Price (High to Low)',
    'A-Z',
    'Z-A',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sortOptions.length,
            itemBuilder: (context, index) {
              final option = _sortOptions[index];
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selectedSort,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSort = value;
                    });
                    widget.onSortChanged(value);
                  }
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSortChanged(_selectedSort);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

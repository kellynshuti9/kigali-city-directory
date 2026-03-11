import 'package:flutter/material.dart';
import '../../models/listing_model.dart';
import '../../utils/constants.dart';
import '../listing_details/listing_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Cafés',
    'Restaurants',
    'Hospitals',
    'Pharmacies',
    'Police',
    'Banks',
    'Parks',
    'Schools',
    'Libraries',
  ];

  final List<Map<String, dynamic>> allResults = const [
    {
      'name': 'Kimironko Café',
      'category': 'Cafés',
      'rating': 4.5,
      'distance': 0.6,
      'reviews': 45,
      'address': 'KG 11 Ave, Kimironko',
      'contact': '+250 788 123 456',
      'description': 'A cozy café with great coffee and friendly staff.',
      'lat': -1.9441,
      'lng': 30.0619,
    },
    {
      'name': 'Green Bean Coffee',
      'category': 'Cafés',
      'rating': 4.2,
      'distance': 1.0,
      'reviews': 32,
      'address': 'KG 7 Ave, Kacyiru',
      'contact': '+250 788 789 012',
      'description': 'Specialty coffee and pastries.',
      'lat': -1.9441,
      'lng': 30.0619,
    },
    {
      'name': 'Umuganda Coffee',
      'category': 'Cafés',
      'rating': 4.7,
      'distance': 1.2,
      'reviews': 28,
      'address': 'KN 3 Rd, Nyarutarama',
      'contact': '+250 788 345 678',
      'description': 'Organic coffee with a view.',
      'lat': -1.9441,
      'lng': 30.0619,
    },
    {
      'name': 'Kigali Central Hospital',
      'category': 'Hospitals',
      'rating': 4.3,
      'distance': 2.1,
      'reviews': 128,
      'address': 'KN 4 Ave, Kacyiru',
      'contact': '+250 788 111 222',
      'description': 'Central hospital with emergency services.',
      'lat': -1.9441,
      'lng': 30.0619,
    },
    {
      'name': 'Rwandex Pharmacy',
      'category': 'Pharmacies',
      'rating': 4.1,
      'distance': 1.5,
      'reviews': 67,
      'address': 'KK 15 Rd, Kicukiro',
      'contact': '+250 788 333 444',
      'description': '24-hour pharmacy with prescription services.',
      'lat': -1.9441,
      'lng': 30.0619,
    },
    {
      'name': 'Bank of Kigali',
      'category': 'Banks',
      'rating': 4.0,
      'distance': 0.8,
      'reviews': 53,
      'address': 'KN 3 Rd, Kacyiru',
      'contact': '+250 788 555 666',
      'description': 'Full-service banking and ATMs.',
      'lat': -1.9441,
      'lng': 30.0619,
    },
  ];

  List<Map<String, dynamic>> get filteredResults {
    var results = allResults;
    
    
    if (_searchController.text.isNotEmpty) {
      results = results.where((item) =>
        item['name'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    
    if (_selectedCategory != 'All') {
      results = results.where((item) =>
        item['category'] == _selectedCategory
      ).toList();
    }
    
    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryBlue),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.primaryBlue),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),

          
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.lightGrey,
                    selectedColor: AppColors.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primaryBlue,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    checkmarkColor: AppColors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filteredResults.length} results found',
                  style: TextStyle(
                    color: Colors.grey.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          
          Expanded(
            child: filteredResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final item = filteredResults[index];
                      return _buildSearchResultCard(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
       
        final listing = Listing(
          id: 'search_${DateTime.now().millisecondsSinceEpoch}_${item['name']}',
          name: item['name'] as String,
          category: item['category'] as String,
          address: item['address'] as String,
          contactNumber: item['contact'] as String,
          description: item['description'] as String,
          latitude: (item['lat'] as num).toDouble(),
          longitude: (item['lng'] as num).toDouble(),
          createdBy: 'user1',
          timestamp: DateTime.now(),
          rating: (item['rating'] as num).toDouble(),
          reviewCount: item['reviews'] as int,
          distance: (item['distance'] as num).toDouble(),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListingDetailsScreen(listing: listing), 
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(item['category'] as String),
                color: AppColors.accentYellow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['category'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accentYellow,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            item['rating'].toString(),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 11,
                            color: Colors.grey.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item['distance']} km',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item['reviews']} reviews',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.bookmark_border,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Cafés':
        return Icons.local_cafe;
      case 'Restaurants':
        return Icons.restaurant;
      case 'Hospitals':
        return Icons.local_hospital;
      case 'Pharmacies':
        return Icons.local_pharmacy;
      case 'Police':
        return Icons.local_police;
      case 'Banks':
        return Icons.account_balance;
      case 'Parks':
        return Icons.park;
      case 'Schools':
        return Icons.school;
      case 'Libraries':
        return Icons.local_library;
      default:
        return Icons.place;
    }
  }
}
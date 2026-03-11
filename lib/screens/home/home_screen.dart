import 'package:flutter/material.dart';
import '../../models/listing_model.dart';
import '../../utils/constants.dart';
import '../listing_details/listing_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  final List<Map<String, dynamic>> categories = const [
    {'name': 'Cafés', 'icon': Icons.local_cafe, 'count': 12},
    {'name': 'Restaurants', 'icon': Icons.restaurant, 'count': 24},
    {'name': 'Hospitals', 'icon': Icons.local_hospital, 'count': 8},
    {'name': 'Pharmacies', 'icon': Icons.local_pharmacy, 'count': 15},
    {'name': 'Police', 'icon': Icons.local_police, 'count': 5},
    {'name': 'Banks', 'icon': Icons.account_balance, 'count': 10},
    {'name': 'Parks', 'icon': Icons.park, 'count': 7},
    {'name': 'Schools', 'icon': Icons.school, 'count': 20},
  ];

 
  final List<Map<String, dynamic>> nearYou = const [
    {
      'name': 'Kimironko Café',
      'category': 'Café',
      'rating': 4.5,
      'distance': 0.6,
      'reviews': 45,
      'address': 'KG 11 Ave, Kimironko'
    },
    {
      'name': 'Green Bean Coffee',
      'category': 'Café',
      'rating': 4.2,
      'distance': 1.0,
      'reviews': 32,
      'address': 'KG 7 Ave, Kacyiru'
    },
    {
      'name': 'Umuganda Coffee',
      'category': 'Café',
      'rating': 4.7,
      'distance': 1.2,
      'reviews': 28,
      'address': 'KN 3 Rd, Nyarutarama'
    },
    {
      'name': 'Rownda Brew',
      'category': 'Café',
      'rating': 4.0,
      'distance': 4.2,
      'reviews': 18,
      'address': 'KG 546 St, Kicukiro'
    },
  ];

 
  final List<Map<String, dynamic>> services = const [
    {
      'name': 'Kigali Central Hospital',
      'category': 'Hospital',
      'rating': 4.3,
      'distance': 2.1,
      'reviews': 128,
      'address': 'KN 4 Ave, Kacyiru'
    },
    {
      'name': 'Rwandex Pharmacy',
      'category': 'Pharmacy',
      'rating': 4.1,
      'distance': 1.5,
      'reviews': 67,
      'address': 'KK 15 Rd, Kicukiro'
    },
    {
      'name': 'Kigali Public Library',
      'category': 'Library',
      'rating': 4.6,
      'distance': 3.0,
      'reviews': 92,
      'address': 'KN 67 St, Nyarugenge'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              _buildHeader(),

              
              _buildSearchBar(context),

              const SizedBox(height: 20),

             
              _buildSectionHeader('Categories', onSeeAll: () {}),
              const SizedBox(height: 12),

             
              _buildCategoryGrid(),

              const SizedBox(height: 24),

              
              _buildSectionHeader('Near You', onSeeAll: () {}),
              const SizedBox(height: 8),

             
              _buildListingsSection(nearYou, context),

              const SizedBox(height: 24),

              
              _buildSectionHeader('Services', onSeeAll: () {}),
              const SizedBox(height: 8),

              _buildListingsSection(services, context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kigali City',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                'Discover places near you',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryBlue),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Search for places...',
              prefixIcon: Icon(Icons.search, color: AppColors.primaryBlue),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
            ),
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

 
  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
           
          },
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: AppColors.accentYellow,
                  size: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category['name'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${category['count']}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

 
  Widget _buildListingsSection(List<Map<String, dynamic>> items, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildListingCard(context, items[index]);
      },
    );
  }

  
  Widget _buildListingCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        
        final listing = Listing(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          name: item['name'] as String,
          category: item['category'] as String,
          address: item['address'] as String,
          contactNumber: '+250 788 123 456',
          description: 'Description for ${item['name']}',
          latitude: -1.9441,
          longitude: 30.0619,
          createdBy: 'user1',
          timestamp: DateTime.now(),
          rating: (item['rating'] as num).toDouble(),
          reviewCount: item['reviews'] as int,
          distance: (item['distance'] as num).toDouble(),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListingDetailsScreen(listing: listing), // FIXED: Passing listing object
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(item['category'] as String),
                color: AppColors.accentYellow,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),

         
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.accentYellow,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['category'] as String,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        size: 12,
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 12,
                        color: Colors.grey.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${item['reviews']} reviews',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['address'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.bookmark_border,
                color: AppColors.primaryBlue,
                size: 20,
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
      case 'Café':
      case 'Cafés':
        return Icons.local_cafe;
      case 'Restaurant':
      case 'Restaurants':
        return Icons.restaurant;
      case 'Hospital':
      case 'Hospitals':
        return Icons.local_hospital;
      case 'Pharmacy':
      case 'Pharmacies':
        return Icons.local_pharmacy;
      case 'Police Station':
      case 'Police':
        return Icons.local_police;
      case 'Bank':
      case 'Banks':
        return Icons.account_balance;
      case 'Park':
      case 'Parks':
        return Icons.park;
      case 'School':
      case 'Schools':
        return Icons.school;
      case 'Library':
      case 'Libraries':
        return Icons.local_library;
      default:
        return Icons.place;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_provider.dart';
import '../../widgets/listing_card.dart';
import '../../models/listing_model.dart';

class DirectoryScreen extends ConsumerStatefulWidget {
  const DirectoryScreen({super.key});

  @override
  ConsumerState<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends ConsumerState<DirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const Color darkBlue = Color.fromARGB(255, 2, 45, 80);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(allListingsProvider);
    final filteredListings = ref.watch(filteredListingsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kigali City',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_outlined, color: darkBlue),
          ),
        ],
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a service...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: darkBlue.withValues(alpha: 0.7)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: darkBlue),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
          ),

        
          categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) return const SizedBox();
              return SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    final count = listingsAsync.value?.where(
                      (l) => l.category == category
                    ).length ?? 0;
                    
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          ref.read(selectedCategoryProvider.notifier).state = null;
                        } else {
                          ref.read(selectedCategoryProvider.notifier).state = category;
                        }
                      },
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isSelected ? darkBlue : darkBlue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getCategoryIcon(category),
                                color: isSelected ? Colors.white : darkBlue,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? darkBlue : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 8),

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchQuery.isNotEmpty || selectedCategory != null
                      ? '${filteredListings.length} results found'
                      : 'All listings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (searchQuery.isNotEmpty || selectedCategory != null)
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                      ref.read(selectedCategoryProvider.notifier).state = null;
                    },
                    child: const Text('Clear filters'),
                  ),
              ],
            ),
          ),

          
          Expanded(
            child: listingsAsync.when(
              data: (allListings) {
                if (allListings.isEmpty) {
                  return const Center(
                    child: Text('No listings available'),
                  );
                }

                if (filteredListings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No listings found',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredListings.length,
                  itemBuilder: (context, index) {
                    return ListingCard(
                      listing: filteredListings[index],
                      showBookmark: true,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
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
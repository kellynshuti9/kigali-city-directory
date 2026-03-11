import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart'; 
import '../models/listing_model.dart';
import '../services/auth_service.dart';

final allListingsProvider = StreamProvider<List<Listing>>((ref) {
  return ref.watch(databaseServiceProvider).getListings();
});

final userListingsProvider = StreamProvider<List<Listing>>((ref) {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(databaseServiceProvider).getUserListings(user.uid);
});

final categoriesProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(databaseServiceProvider).getCategories();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredListingsProvider = Provider<List<Listing>>((ref) {
  final listingsAsync = ref.watch(allListingsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  
  if (listingsAsync is! AsyncData<List<Listing>>) return [];
  
  var listings = listingsAsync.value;
  
  if (category != null && category.isNotEmpty) {
    listings = listings.where((l) => l.category == category).toList();
  }
  
  if (query.isNotEmpty) {
    listings = listings.where((l) => 
      l.name.toLowerCase().contains(query) ||
      l.address.toLowerCase().contains(query)
    ).toList();
  }
  
  return listings;
});

class ListingNotifier extends StateNotifier<AsyncValue<void>> {
  final DatabaseService _service;
  
  ListingNotifier(this._service) : super(const AsyncValue.data(null));
  
  Future<void> addListing(Listing listing) async {
    state = const AsyncValue.loading();
    try {
      await _service.createListing(listing);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateListing(Listing listing) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateListing(listing);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> deleteListing(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteListing(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final listingNotifierProvider = StateNotifierProvider<ListingNotifier, AsyncValue<void>>((ref) {
  return ListingNotifier(ref.watch(databaseServiceProvider));
});
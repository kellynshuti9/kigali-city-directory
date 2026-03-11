import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/listing_model.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  
  Stream<List<Listing>> getListings() {
    print(' [DatabaseService] Getting all listings stream...');
    return _db.child('listings').onValue.map((event) {
      print(' [DatabaseService] Data received from Firebase');
      final listings = <Listing>[];
      final data = event.snapshot.value;
      
      print(' [DatabaseService] Raw data: $data');
      
      if (data != null) {
        if (data is Map) {
          print(' [DatabaseService] Data is a Map with ${data.length} entries');
          data.forEach((key, value) {
            print(' [DatabaseService] Processing key: $key');
            if (value is Map) {
              final map = Map<String, dynamic>.from(value);
              listings.add(Listing.fromMap(key.toString(), map));
              print(' [DatabaseService] Added listing: ${map['name']}');
            } else {
              print(' [DatabaseService] Value for key $key is not a Map: $value');
            }
          });
        } else {
          print(' [DatabaseService] Data is not a Map: ${data.runtimeType}');
        }
      } else {
        print(' [DatabaseService] No data found in database');
      }
      
      print(' [DatabaseService] Returning ${listings.length} listings');
      return listings;
    });
  }

  
  Stream<List<Listing>> getUserListings(String userId) {
    print(' [DatabaseService] Getting user listings for userId: $userId');
    return _db.child('listings').onValue.map((event) {
      final listings = <Listing>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          final map = Map<String, dynamic>.from(value as Map);
          if (map['createdBy'] == userId) {
            listings.add(Listing.fromMap(key.toString(), map));
          }
        });
      }
      print(' [DatabaseService] Found ${listings.length} listings for user');
      return listings;
    });
  }

  
  Stream<List<String>> getCategories() {
    print(' [DatabaseService] Getting categories stream...');
    return _db.child('listings').onValue.map((event) {
      final Set<String> categories = {};
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          final map = Map<String, dynamic>.from(value as Map);
          categories.add(map['category']);
        });
      }
      final sortedCategories = categories.toList()..sort();
      print(' [DatabaseService] Found categories: $sortedCategories');
      return sortedCategories;
    });
  }

 
  Future<Listing?> getListing(String id) async {
    print(' [DatabaseService] Getting listing with id: $id');
    final snapshot = await _db.child('listings/$id').get();
    if (snapshot.exists) {
      print(' [DatabaseService] Listing found');
      return Listing.fromMap(id, Map<String, dynamic>.from(snapshot.value as Map));
    }
    print(' [DatabaseService] Listing not found');
    return null;
  }

  
  Future<void> createListing(Listing listing) async {
    print(' [DatabaseService] Creating new listing: ${listing.name}');
    final newRef = _db.child('listings').push();
    await newRef.set(listing.toMap());
    print(' [DatabaseService] Listing created with id: ${newRef.key}');
  }

 
  Future<void> updateListing(Listing listing) async {
    print(' [DatabaseService] Updating listing: ${listing.id}');
    await _db.child('listings/${listing.id}').update(listing.toMap());
    print(' [DatabaseService] Listing updated');
  }

  Future<void> deleteListing(String id) async {
    print(' [DatabaseService] Deleting listing: $id');
    await _db.child('listings/$id').remove();
    print(' [DatabaseService] Listing deleted');
  }
}
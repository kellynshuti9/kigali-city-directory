import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/listing_model.dart';
import '../screens/listing_details/listing_details_screen.dart';

class ListingCard extends StatefulWidget {
  final Listing listing;
  final bool showBookmark;

  const ListingCard({
    super.key, 
    required this.listing,
    this.showBookmark = true,
  });

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool _isBookmarked = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isChecking = false;
      });
      return;
    }

    try {
      final db = FirebaseDatabase.instance.ref();
      final snapshot = await db.child('bookmarks').child(user.uid).child(widget.listing.id).get();
      
      setState(() {
        _isBookmarked = snapshot.exists;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to bookmark places'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isChecking = true;
    });

    final db = FirebaseDatabase.instance.ref();
    final bookmarkRef = db.child('bookmarks').child(user.uid).child(widget.listing.id);

    try {
      if (_isBookmarked) {
        await bookmarkRef.remove();
        setState(() {
          _isBookmarked = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.listing.name} removed from bookmarks'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        await bookmarkRef.set(widget.listing.id);
        setState(() {
          _isBookmarked = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.listing.name} added to bookmarks'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color.fromARGB(255, 2, 45, 80);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListingDetailsScreen(listing: widget.listing),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: darkBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(widget.listing.category),
                color: darkBlue,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.listing.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.listing.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                 
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: darkBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.listing.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.listing.address,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.listing.reviewCount} reviews',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            
            if (widget.showBookmark)
              _isChecking
                  ? Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.all(8),
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      onPressed: _toggleBookmark,
                      icon: Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: _isBookmarked ? Colors.amber : darkBlue,
                        size: 22,
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
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: isSelected ? AppColors.white : AppColors.primaryBlue,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.primaryBlue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? AppColors.white.withValues(alpha: 0.8) : Colors.grey.shade600,
              ),
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
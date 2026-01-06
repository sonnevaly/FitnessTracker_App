import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FilterChips extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const FilterChips({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          _buildChip('This Week'),
          SizedBox(width: 12),
          _buildChip('This Month'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = selectedPeriod == label;
    
    return GestureDetector(
      onTap: () => onPeriodChanged(label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.cardDark.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
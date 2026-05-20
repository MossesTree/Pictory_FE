import 'package:flutter/material.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            backgroundColor: HomeTheme.surface,
            selectedColor: HomeTheme.yellow,
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : HomeTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? HomeTheme.yellow : HomeTheme.surfaceLight,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

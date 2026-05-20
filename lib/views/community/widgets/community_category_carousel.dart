import 'package:flutter/material.dart';
import 'package:picktory/models/community_category.dart';
import 'package:picktory/views/community/community_theme.dart';

class CommunityCategoryCarousel extends StatelessWidget {
  const CommunityCategoryCarousel({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<CommunityCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(category.id),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? CommunityTheme.textPrimary
                        : CommunityTheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: CommunityTheme.border),
                  ),
                  child: Text(
                    category.label.length <= 3
                        ? category.label
                        : category.label.substring(0, 2),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : CommunityTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: selected
                        ? CommunityTheme.textPrimary
                        : CommunityTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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

  static const double _itemWidth = 56;
  static const double _circleSize = 48;
  static const double _carouselHeight = 80;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _carouselHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(category.id),
            child: SizedBox(
              width: _itemWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: _circleSize,
                    height: _circleSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? CommunityTheme.textPrimary
                          : CommunityTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: CommunityTheme.border),
                    ),
                    child: Text(
                      _circleLabel(category.label),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected
                          ? CommunityTheme.textPrimary
                          : CommunityTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _circleLabel(String label) {
    if (label.length <= 3) {
      return label;
    }
    return label.substring(0, 2);
  }
}

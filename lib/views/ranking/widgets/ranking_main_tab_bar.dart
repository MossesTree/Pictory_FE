import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_feed.dart';

class RankingMainTabBar extends StatelessWidget {
  const RankingMainTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RankingMainTab selected;
  final ValueChanged<RankingMainTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RankingMainTab.values.map((tab) {
        final isActive = tab == selected;
        return Expanded(
          child: InkWell(
            onTap: () => onSelected(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tab.label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

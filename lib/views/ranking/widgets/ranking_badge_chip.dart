import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_badge.dart';

class RankingBadgeChip extends StatelessWidget {
  const RankingBadgeChip({super.key, required this.badge});

  final RankingBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badge.label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

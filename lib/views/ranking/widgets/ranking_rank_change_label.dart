import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_rank_change.dart';

class RankingRankChangeLabel extends StatelessWidget {
  const RankingRankChangeLabel({super.key, required this.change});

  final RankingRankChange change;

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (change) {
      RankingRankChangeUp(:final steps) => ('↑$steps', Colors.green),
      RankingRankChangeDown(:final steps) => ('↓$steps', Colors.red),
      RankingRankChangeNone() => ('—', Colors.grey),
    };

    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

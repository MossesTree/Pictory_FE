import 'package:flutter/material.dart';

class RankingListHeader extends StatelessWidget {
  const RankingListHeader({
    super.key,
    required this.scoreLabel,
  });

  final String scoreLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 36,
            child: Text('순위', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          const Expanded(
            child: Text('유저', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          SizedBox(
            width: 56,
            child: Text(
              scoreLabel,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(
            width: 36,
            child: Text(
              '변동',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

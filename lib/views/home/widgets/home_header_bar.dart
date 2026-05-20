import 'package:flutter/material.dart';

class HomeHeaderBar extends StatelessWidget {
  const HomeHeaderBar({
    super.key,
    required this.nickname,
    required this.points,
    required this.hasUnreadNotifications,
  });

  final String nickname;
  final int points;
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('LOGO', style: TextStyle(fontSize: 10)),
          ),
          const Spacer(),
          Text(nickname),
          const SizedBox(width: 8),
          Row(
            children: [
              const Text('p', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 2),
              Text(
                _formatPoints(points),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none),
              if (hasUnreadNotifications)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPoints(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

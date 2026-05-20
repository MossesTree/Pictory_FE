import 'package:flutter/material.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeHeaderBar extends StatelessWidget {
  const HomeHeaderBar({
    super.key,
    required this.nickname,
    required this.points,
    required this.hasUnreadNotifications,
    this.onNotificationTap,
  });

  final String nickname;
  final int points;
  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: HomeTheme.surfaceLight,
            child: Text(
              nickname.isNotEmpty ? nickname[0] : '?',
              style: const TextStyle(color: HomeTheme.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              nickname,
              style: const TextStyle(
                color: HomeTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.monetization_on, color: HomeTheme.yellow, size: 18),
          const SizedBox(width: 4),
          Text(
            _formatPoints(points),
            style: const TextStyle(
              color: HomeTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: HomeTheme.textPrimary,
                ),
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

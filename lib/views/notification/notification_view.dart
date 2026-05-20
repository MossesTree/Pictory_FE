import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/app_notification.dart';
import 'package:picktory/viewmodels/notification_view_model.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/widgets/mission_scaffold.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key, required this.viewModel});

  final NotificationViewModel viewModel;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  NotificationViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return MissionScaffold(
          title: '알림',
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.isEmpty
                  ? _EmptyState(
                      onGoMissions: () => context.go(AppRoute.home.path),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _NotificationTile(
                          notification: viewModel.items[index],
                        );
                      },
                    ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onGoMissions});

  final VoidCallback onGoMissions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_active,
              size: 72,
              color: HomeTheme.yellow,
            ),
            const SizedBox(height: 16),
            const Text(
              '아직 알림이 없어요',
              style: TextStyle(
                color: HomeTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            MissionYellowButton(
              label: '미션 보러가기',
              onPressed: onGoMissions,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  IconData get _icon {
    switch (notification.type) {
      case AppNotificationType.result:
        return Icons.emoji_events_outlined;
      case AppNotificationType.mission:
        return Icons.flag_outlined;
      case AppNotificationType.reward:
        return Icons.monetization_on_outlined;
      case AppNotificationType.ranking:
        return Icons.leaderboard_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HomeTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: HomeTheme.yellow),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    color: HomeTheme.textPrimary,
                    fontWeight: notification.isRead
                        ? FontWeight.w500
                        : FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: const TextStyle(color: HomeTheme.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            notification.timeLabel,
            style: const TextStyle(
              color: HomeTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/widgets/picktory_async_state.dart';
import 'package:picktory/models/app_notification.dart';
import 'package:picktory/viewmodels/notification_view_model.dart';

/// IA N-1 알림 목록 / N-2 빈 상태
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

  /// IA N-1 알림 탭 시 타입별 라우팅
  /// - 상세 화면이 있는 타입은 push (뒤로가기로 알림 목록 복귀)
  /// - 탭 자체가 목적지인 타입은 go (알림 목록 닫고 탭 전환)
  Future<void> _handleTap(AppNotification notification) async {
    await viewModel.markAsRead(notification.id);
    if (!mounted) return;

    switch (notification.type) {
      case AppNotificationType.result:
        if (notification.targetId != null) {
          context.pushReplacement(
            AppRoute.missionResultPath(notification.targetId!),
          );
        }
      case AppNotificationType.deadline:
      case AppNotificationType.newMission:
        if (notification.targetId != null) {
          context.pushReplacement(
            AppRoute.missionDetailPath(notification.targetId!),
          );
        }
      case AppNotificationType.comment:
        if (notification.targetId != null) {
          context.pushReplacement(
            AppRoute.communityPostPath(notification.targetId!),
          );
        }
      case AppNotificationType.reward:
        context.go(AppRoute.my.path);
      case AppNotificationType.ranking:
        context.go(AppRoute.ranking.path);
      case AppNotificationType.attendanceReminder:
        context.go(AppRoute.benefits.path);
      case AppNotificationType.event:
        // 이벤트 페이지가 없으면 홈으로 (IA 정책)
        context.go(AppRoute.home.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          // IA N-1 우측 상단 X 표시: 탭 시 기존 화면 표시
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return PicktoryAsyncState.loading();
          }
          if (viewModel.errorMessage != null && viewModel.items.isEmpty) {
            return PicktoryAsyncState.error(
              message: viewModel.errorMessage!,
              onRetry: viewModel.load,
            );
          }
          if (viewModel.isEmpty) {
            // IA N-2 빈 상태
            return PicktoryAsyncState.empty(
              message: '아직 알림이 없어요',
              actionLabel: '미션 보러가기',
              onAction: () => context.go(AppRoute.home.path),
              icon: Icons.notifications_off_outlined,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(PicktorySpacing.md),
            itemCount: viewModel.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              return _NotificationTile(
                notification: item,
                onTap: () => _handleTap(item),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  static const _accent = Color(0xFFFF6B00);

  IconData get _icon {
    switch (notification.type) {
      case AppNotificationType.result:
        return Icons.emoji_events_outlined;
      case AppNotificationType.deadline:
        return Icons.timer_outlined;
      case AppNotificationType.newMission:
        return Icons.flag_outlined;
      case AppNotificationType.reward:
        return Icons.monetization_on_outlined;
      case AppNotificationType.ranking:
        return Icons.leaderboard_outlined;
      case AppNotificationType.comment:
        return Icons.mode_comment_outlined;
      case AppNotificationType.attendanceReminder:
        return Icons.calendar_today_outlined;
      case AppNotificationType.event:
        return Icons.campaign_outlined;
    }
  }

  Color get _iconBg {
    switch (notification.type) {
      case AppNotificationType.result:
      case AppNotificationType.reward:
        return const Color(0xFFFFF4D6);
      case AppNotificationType.deadline:
        return const Color(0xFFFFE4E0);
      case AppNotificationType.newMission:
      case AppNotificationType.event:
        return const Color(0xFFEDE8F7);
      case AppNotificationType.ranking:
        return const Color(0xFFE7F5FF);
      case AppNotificationType.comment:
        return const Color(0xFFF3F3F5);
      case AppNotificationType.attendanceReminder:
        return const Color(0xFFE4F8E1);
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case AppNotificationType.result:
      case AppNotificationType.reward:
        return const Color(0xFFE8A317);
      case AppNotificationType.deadline:
        return const Color(0xFFE53935);
      case AppNotificationType.newMission:
      case AppNotificationType.event:
        return const Color(0xFF8F6BFF);
      case AppNotificationType.ranking:
        return const Color(0xFF1E88E5);
      case AppNotificationType.comment:
        return const Color(0xFF616161);
      case AppNotificationType.attendanceReminder:
        return const Color(0xFF43A047);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead ? Colors.white : const Color(0xFFFFF8F2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(PicktorySpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: const Color(0xFF1A1A1A),
                              fontSize: 14,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(left: 6, top: 2),
                            decoration: const BoxDecoration(
                              color: _accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.timeLabel,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

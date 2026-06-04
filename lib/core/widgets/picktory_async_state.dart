import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';

/// 공통 빈 상태 / 에러 / 로딩 위젯
/// IA 전반에서 Empty/Error/Loading 표준 UX로 사용
class PicktoryAsyncState {
  PicktoryAsyncState._();

  static Widget loading({Color? color}) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? const Color(0xFF8F6BFF),
        strokeWidth: 2.4,
      ),
    );
  }

  static Widget empty({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData icon = Icons.inbox_outlined,
  }) {
    return _PicktoryStateView(
      icon: icon,
      iconColor: PicktoryColors.home.textTertiary,
      title: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static Widget error({
    required String message,
    String actionLabel = '다시 시도',
    required VoidCallback onRetry,
  }) {
    return _PicktoryStateView(
      icon: Icons.error_outline_rounded,
      iconColor: const Color(0xFFE53935),
      title: message,
      actionLabel: actionLabel,
      onAction: onRetry,
    );
  }
}

class _PicktoryStateView extends StatelessWidget {
  const _PicktoryStateView({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor),
            const SizedBox(height: PicktorySpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF757575),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: PicktorySpacing.lg),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8F6BFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PicktorySpacing.xl,
                    vertical: PicktorySpacing.sm,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

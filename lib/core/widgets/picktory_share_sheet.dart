import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';

/// IA M-1/M-3 외부 공유 BottomSheet (Figma 다크 공유 시트)
class PicktoryShareSheet extends StatelessWidget {
  const PicktoryShareSheet({
    super.key,
    required this.shareUrl,
    this.title,
    this.subtitle,
  });

  final String shareUrl;
  final String? title;
  final String? subtitle;

  static Future<void> show(
    BuildContext context, {
    required String shareUrl,
    String? title,
    String? subtitle,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => PicktoryShareSheet(
        shareUrl: shareUrl,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: shareUrl));
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: const Text('링크가 복사됐어요!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _stubShare(BuildContext context, String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? 'Picktory 미션';
    final displaySubtitle = subtitle ?? shareUrl;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PicktorySpacing.md,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8F6BFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              displaySubtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PicktorySpacing.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareIconAction(
                      icon: Icons.link_rounded,
                      label: '링크 복사',
                      color: const Color(0xFF3A3A3C),
                      onTap: () => _copyLink(context),
                    ),
                    _ShareIconAction(
                      icon: Icons.chat_bubble_rounded,
                      label: '카카오톡',
                      color: const Color(0xFFFFE812),
                      iconColor: const Color(0xFF3A1D1D),
                      onTap: () => _stubShare(
                        context,
                        '카카오톡 공유는 곧 제공될 예정입니다',
                      ),
                    ),
                    _ShareIconAction(
                      icon: Icons.camera_alt_rounded,
                      label: '인스타',
                      color: const Color(0xFFE1306C),
                      onTap: () => _stubShare(
                        context,
                        '인스타그램 공유는 곧 제공될 예정입니다',
                      ),
                    ),
                    _ShareIconAction(
                      icon: Icons.more_horiz_rounded,
                      label: '더보기',
                      color: const Color(0xFF3A3A3C),
                      onTap: () => _stubShare(
                        context,
                        '추가 공유 옵션은 곧 제공될 예정입니다',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _DarkListTile(
                icon: Icons.content_copy_outlined,
                label: '링크를 클립보드에 복사',
                onTap: () => _copyLink(context),
              ),
              _DarkListTile(
                icon: Icons.open_in_browser_rounded,
                label: '브라우저에서 열기',
                onTap: () => _stubShare(
                  context,
                  '브라우저 열기는 곧 제공될 예정입니다',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Color(0xFF8F6BFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareIconAction extends StatelessWidget {
  const _ShareIconAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _DarkListTile extends StatelessWidget {
  const _DarkListTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PicktorySpacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.85), size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

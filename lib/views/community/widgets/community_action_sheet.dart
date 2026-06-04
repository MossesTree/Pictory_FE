import 'package:flutter/material.dart';
import 'package:picktory/models/community_comment.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/views/community/community_theme.dart';

enum CommunityPostAction {
  edit,
  delete,
  report,
  block,
  share,
  viewMission,
}

enum CommunityCommentAction {
  edit,
  delete,
  report,
  block,
}

enum CommunityFeedMoreAction {
  refresh,
  notifications,
  notice,
}

Future<CommunityPostAction?> showCommunityPostActionSheet(
  BuildContext context, {
  required CommunityPost post,
}) {
  return showModalBottomSheet<CommunityPostAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ActionSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (post.isMine) ...[
              _ActionTile(
                icon: Icons.edit_outlined,
                label: '수정하기',
                onTap: () =>
                    Navigator.pop(context, CommunityPostAction.edit),
              ),
              _ActionTile(
                icon: Icons.delete_outline,
                label: '삭제하기',
                isDanger: true,
                onTap: () =>
                    Navigator.pop(context, CommunityPostAction.delete),
              ),
            ] else ...[
              _ActionTile(
                icon: Icons.flag_outlined,
                label: '신고하기',
                isDanger: true,
                onTap: () =>
                    Navigator.pop(context, CommunityPostAction.report),
              ),
              _ActionTile(
                icon: Icons.block,
                label: '이 유저 차단하기',
                isDanger: true,
                onTap: () =>
                    Navigator.pop(context, CommunityPostAction.block),
              ),
            ],
            if (post.isMissionShare && post.linkedMissionId != null)
              _ActionTile(
                icon: Icons.emoji_events_outlined,
                label: '원본 미션 보기',
                onTap: () => Navigator.pop(
                  context,
                  CommunityPostAction.viewMission,
                ),
              ),
            _ActionTile(
              icon: Icons.link,
              label: '링크 복사',
              onTap: () => Navigator.pop(context, CommunityPostAction.share),
            ),
          ],
        ),
      );
    },
  );
}

/// IA C-1 헤더 더보기 시트
Future<CommunityFeedMoreAction?> showCommunityFeedMoreSheet(
  BuildContext context,
) {
  return showModalBottomSheet<CommunityFeedMoreAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ActionSheetContainer(
        title: '더보기',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionTile(
              icon: Icons.refresh,
              label: '새로고침',
              onTap: () =>
                  Navigator.pop(context, CommunityFeedMoreAction.refresh),
            ),
            _ActionTile(
              icon: Icons.notifications_none,
              label: '알림 보기',
              onTap: () => Navigator.pop(
                context,
                CommunityFeedMoreAction.notifications,
              ),
            ),
            _ActionTile(
              icon: Icons.campaign_outlined,
              label: '공지사항',
              onTap: () =>
                  Navigator.pop(context, CommunityFeedMoreAction.notice),
            ),
          ],
        ),
      );
    },
  );
}

Future<CommunityCommentAction?> showCommunityCommentActionSheet(
  BuildContext context, {
  required CommunityComment comment,
}) {
  return showModalBottomSheet<CommunityCommentAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ActionSheetContainer(
        title: comment.isMine ? '내 댓글' : '${comment.displayAuthor}님의 댓글',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (comment.isMine) ...[
              _ActionTile(
                icon: Icons.edit_outlined,
                label: '수정하기',
                onTap: () =>
                    Navigator.pop(context, CommunityCommentAction.edit),
              ),
              _ActionTile(
                icon: Icons.delete_outline,
                label: '삭제하기',
                isDanger: true,
                onTap: () =>
                    Navigator.pop(context, CommunityCommentAction.delete),
              ),
            ] else ...[
              _ActionTile(
                icon: Icons.flag_outlined,
                label: '신고하기',
                isDanger: true,
                onTap: () =>
                    Navigator.pop(context, CommunityCommentAction.report),
              ),
              _ActionTile(
                icon: Icons.block,
                label: '이 유저 차단하기',
                isDanger: true,
                onTap: () =>
                    Navigator.pop(context, CommunityCommentAction.block),
              ),
            ],
          ],
        ),
      );
    },
  );
}

Future<String?> showCommunityCreateSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return _ActionSheetContainer(
        title: '무엇을 하시겠어요?',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionTile(
              icon: Icons.edit_outlined,
              label: '글 작성하기',
              subtitle: '피드에 자유롭게 글을 남겨요',
              showChevron: true,
              onTap: () => Navigator.pop(context, 'compose'),
            ),
            _ActionTile(
              icon: Icons.lightbulb_outline,
              label: '미션 건의하기',
              subtitle: '원하는 미션을 운영팀에 제안해요',
              showChevron: true,
              onTap: () => Navigator.pop(context, 'suggest'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ActionSheetContainer extends StatelessWidget {
  const _ActionSheetContainer({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: CommunityTheme.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CommunityTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: 16),
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.isDanger = false,
    this.showChevron = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDanger;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? CommunityTheme.danger : CommunityTheme.textPrimary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: showChevron ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/views/community/community_theme.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onMoreTap,
    this.onVoteTap,
  });

  final CommunityPost post;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final VoidCallback? onVoteTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CommunityTheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CommunityTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.headerLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CommunityTheme.textSecondary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onMoreTap,
                  ),
                ],
              ),
              if (post.isMissionShare && post.linkedMissionLabel != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CommunityTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CommunityTheme.border),
                  ),
                  child: Text(
                    post.linkedMissionLabel!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: CommunityTheme.textSecondary),
              ),
              if (post.hasPoll && post.pollOptions.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...post.pollOptions.take(3).map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: OutlinedButton(
                      onPressed: onVoteTap ?? onTap,
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: Text(option),
                    ),
                  ),
                ),
                if (onVoteTap != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onVoteTap,
                      child: const Text('투표하기'),
                    ),
                  ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  _StatIcon(Icons.favorite_border, post.likeCount),
                  const SizedBox(width: 12),
                  _StatIcon(Icons.chat_bubble_outline, post.commentCount),
                  const SizedBox(width: 12),
                  _StatIcon(Icons.remove_red_eye_outlined, post.viewCount),
                  const Spacer(),
                  Text(
                    post.createdAtLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CommunityTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatIcon extends StatelessWidget {
  const _StatIcon(this.icon, this.count);

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: CommunityTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          _formatCount(count),
          style: const TextStyle(
            fontSize: 12,
            color: CommunityTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatCount(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }
}

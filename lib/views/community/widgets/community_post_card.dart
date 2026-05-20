import 'package:flutter/material.dart';
import 'package:picktory/models/community_post.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onMoreTap,
  });

  final CommunityPost post;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.programLabel,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: onMoreTap,
                  ),
                ],
              ),
              if (post.isMissionShare) ...[
                const SizedBox(height: 4),
                const Text(
                  '미션에서 공유됨',
                  style: TextStyle(fontSize: 12, color: Colors.indigo),
                ),
                if (post.linkedMissionLabel != null)
                  Text(post.linkedMissionLabel!),
              ],
              const SizedBox(height: 4),
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(post.content, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(post.displayAuthor),
                  if (post.authorBadge != null) ...[
                    const SizedBox(width: 6),
                    Text(post.authorBadge!, style: const TextStyle(fontSize: 11)),
                  ],
                  const Spacer(),
                  Text('♡ ${post.likeCount}'),
                  const SizedBox(width: 8),
                  Text('□ ${post.commentCount}'),
                  const SizedBox(width: 8),
                  Text('👁 ${post.viewCount}'),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                post.createdAtLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

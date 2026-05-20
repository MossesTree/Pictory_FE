import 'package:flutter/material.dart';
import 'package:picktory/models/community_post.dart';

enum CommunityPostAction {
  edit,
  delete,
  report,
  block,
  share,
}

Future<CommunityPostAction?> showCommunityPostActionSheet(
  BuildContext context, {
  required CommunityPost post,
}) {
  return showModalBottomSheet<CommunityPostAction>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (post.isMine) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('수정하기'),
                onTap: () => Navigator.pop(context, CommunityPostAction.edit),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('삭제하기', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context, CommunityPostAction.delete),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('신고하기'),
                onTap: () => Navigator.pop(context, CommunityPostAction.report),
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('이 유저 차단하기'),
                onTap: () => Navigator.pop(context, CommunityPostAction.block),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('링크 복사'),
              onTap: () => Navigator.pop(context, CommunityPostAction.share),
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> showCommunityCreateSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('글 작성'),
              subtitle: const Text('스레드에 자유롭게 글을 남겨요'),
              onTap: () => Navigator.pop(context, 'compose'),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: const Text('미션 건의하기'),
              subtitle: const Text('원하는 미션을 운영팀에 제안해요'),
              onTap: () => Navigator.pop(context, 'suggest'),
            ),
          ],
        ),
      );
    },
  );
}

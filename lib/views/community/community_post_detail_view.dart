import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/community_comment.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/viewmodels/community_post_detail_view_model.dart';
import 'package:picktory/views/community/widgets/community_action_sheet.dart';

class CommunityPostDetailView extends StatefulWidget {
  const CommunityPostDetailView({super.key, required this.viewModel});

  final CommunityPostDetailViewModel viewModel;

  @override
  State<CommunityPostDetailView> createState() =>
      _CommunityPostDetailViewState();
}

class _CommunityPostDetailViewState extends State<CommunityPostDetailView> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    widget.viewModel.load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleMore() async {
    final post = widget.viewModel.post;
    if (post == null) {
      return;
    }
    final action = await showCommunityPostActionSheet(context, post: post);
    if (!mounted || action == null) {
      return;
    }
    final repo = ServiceLocator.instance.communityRepository;
    switch (action) {
      case CommunityPostAction.edit:
        await context.push(AppRoute.communityComposePath(editPostId: post.id));
        widget.viewModel.load();
      case CommunityPostAction.delete:
        await repo.deletePost(post.id);
        if (mounted) {
          context.pop();
        }
      case CommunityPostAction.report:
        await context.push(
          AppRoute.communityReportPath(
            targetType: 'post',
            targetId: post.id,
          ),
        );
      case CommunityPostAction.block:
        await repo.blockUser(post.authorNickname);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('유저를 차단했습니다.')),
          );
          context.pop();
        }
      case CommunityPostAction.share:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('딥링크가 클립보드에 복사되었습니다.')),
        );
    }
  }

  Future<void> _submitComment() async {
    await widget.viewModel.submitComment();
    if (!mounted) {
      return;
    }
    _commentController.clear();
    widget.viewModel.clearCommentDraft();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final post = viewModel.post;
        final showContent = !viewModel.isLoading && post != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('스레드 상세'),
            actions: [
              if (showContent)
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: _handleMore,
                ),
            ],
          ),
          body: _buildBody(context, viewModel, post),
          bottomNavigationBar: showContent
              ? _CommentInputBar(
                  controller: _commentController,
                  canSubmit: viewModel.canSubmitComment,
                  onChanged: viewModel.updateCommentDraft,
                  onSubmit: _submitComment,
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    CommunityPostDetailViewModel viewModel,
    CommunityPost? post,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }
    if (post == null) {
      return const Center(child: Text('게시물을 찾을 수 없습니다.'));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(post.programLabel),
        const SizedBox(height: 8),
        Text(
          post.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(post.content),
        const SizedBox(height: 8),
        Text('${post.displayAuthor} · ${post.createdAtLabel}'),
        const SizedBox(height: 8),
        Text(
          '♡ ${post.likeCount}  □ ${post.commentCount}  👁 ${post.viewCount}',
        ),
        const Divider(height: 32),
        const Text('댓글', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (viewModel.comments.isEmpty)
          const Text('아직 댓글이 없습니다.')
        else
          ...viewModel.comments.map(
            (comment) => _CommentTile(
              comment: comment,
              onDelete: () => viewModel.deleteComment(comment.id),
              onReport: () => context.push(
                AppRoute.communityReportPath(
                  targetType: 'comment',
                  targetId: comment.id,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CommentInputBar extends StatelessWidget {
  const _CommentInputBar({
    required this.controller,
    required this.canSubmit,
    required this.onChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool canSubmit;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: '댓글 작성...',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 64,
                height: 44,
                child: ElevatedButton(
                  onPressed: canSubmit ? onSubmit : null,
                  child: const Text('등록'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.onDelete,
    required this.onReport,
  });

  final CommunityComment comment;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.displayAuthor,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(comment.displayContent),
                if (comment.isEdited)
                  const Text(
                    '(수정됨)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          if (comment.isMine)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            )
          else
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              onPressed: onReport,
            ),
        ],
      ),
    );
  }
}

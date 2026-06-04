import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/community_comment.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/viewmodels/community_post_detail_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';
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
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    widget.viewModel.load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePostMore() async {
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
      case CommunityPostAction.viewMission:
        final missionId = post.linkedMissionId;
        if (missionId != null) {
          await context.push(AppRoute.missionDetailPath(missionId));
        }
    }
  }

  Future<void> _handleCommentMore(CommunityComment comment) async {
    final action = await showCommunityCommentActionSheet(
      context,
      comment: comment,
    );
    if (!mounted || action == null) {
      return;
    }
    final repo = ServiceLocator.instance.communityRepository;
    switch (action) {
      case CommunityCommentAction.delete:
        await widget.viewModel.deleteComment(comment.id);
      case CommunityCommentAction.report:
        await context.push(
          AppRoute.communityReportPath(
            targetType: 'comment',
            targetId: comment.id,
          ),
        );
      case CommunityCommentAction.block:
        await repo.blockUser(comment.authorNickname);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('유저를 차단했습니다.')),
          );
        }
      case CommunityCommentAction.edit:
        // 임시: 입력바에 기존 내용을 채워 재작성 흐름으로 유도
        _commentController.text = comment.content;
        _commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: comment.content.length),
        );
        widget.viewModel.updateCommentDraft(comment.content);
        FocusScope.of(context).requestFocus(_commentFocusNode);
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
          backgroundColor: CommunityTheme.background,
          appBar: AppBar(
            backgroundColor: CommunityTheme.background,
            title: Text(post?.programLabel.split('|').first.trim() ?? '스레드 상세'),
            actions: [
              if (showContent)
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: _handlePostMore,
                ),
            ],
          ),
          body: _buildBody(context, viewModel, post),
          bottomNavigationBar: showContent
              ? _CommentInputBar(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '브랜드 광고 배너',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Text(
          post.headerLabel,
          style: const TextStyle(
            fontSize: 13,
            color: CommunityTheme.textSecondary,
          ),
        ),
        if (post.isMissionShare && post.linkedMissionId != null) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: () => context.push(
              AppRoute.missionDetailPath(post.linkedMissionId!),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: CommunityTheme.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(post.linkedMissionLabel ?? '공식 미션 보기 →'),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: CommunityTheme.surface,
              child: Text(post.displayAuthor[0]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.displayAuthor,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (post.authorBadge != null) ...[
                        const SizedBox(width: 6),
                        _BadgePill(label: post.authorBadge!),
                      ],
                    ],
                  ),
                  Text(
                    post.createdAtLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CommunityTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          post.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(post.content),
        const SizedBox(height: 12),
        Row(
          children: [
            InkWell(
              onTap: viewModel.togglePostLike,
              child: _Stat(Icons.favorite_border, post.likeCount),
            ),
            const SizedBox(width: 16),
            _Stat(Icons.chat_bubble_outline, post.commentCount),
            const SizedBox(width: 16),
            _Stat(Icons.remove_red_eye_outlined, post.viewCount),
          ],
        ),
        const Divider(height: 32),
        const Text('댓글', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (viewModel.comments.isEmpty)
          const Text(
            '아직 댓글이 없습니다.',
            style: TextStyle(color: CommunityTheme.textSecondary),
          )
        else
          ...viewModel.comments.map(
            (comment) => _CommentTile(
              comment: comment,
              onMore: () => _handleCommentMore(comment),
            ),
          ),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: CommunityTheme.yellow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.count);

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: CommunityTheme.textSecondary),
        const SizedBox(width: 4),
        Text('$count'),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.onMore});

  final CommunityComment comment;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: CommunityTheme.surface,
            child: Text(comment.displayAuthor[0], style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.displayAuthor,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (comment.authorBadge != null) ...[
                      const SizedBox(width: 6),
                      _BadgePill(label: comment.authorBadge!),
                    ],
                    const Spacer(),
                    Text(
                      comment.createdAtLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: CommunityTheme.textSecondary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onMore,
                    ),
                  ],
                ),
                Text(comment.displayContent),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: CommunityTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text('${comment.likeCount}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInputBar extends StatelessWidget {
  const _CommentInputBar({
    required this.controller,
    required this.focusNode,
    required this.canSubmit,
    required this.onChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSubmit;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: CommunityTheme.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                child: Icon(Icons.person, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: '댓글 작성...',
                    filled: true,
                    fillColor: CommunityTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: canSubmit ? onSubmit : null,
                child: const Text(
                  '전송',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

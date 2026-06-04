import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/community_post_kind.dart';
import 'package:picktory/viewmodels/my_community_activity_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

/// IA MY-3 내 커뮤니티 활동 (글/댓글 탭)
class MyCommunityActivityView extends StatefulWidget {
  const MyCommunityActivityView({super.key, required this.viewModel});

  final MyCommunityActivityViewModel viewModel;

  @override
  State<MyCommunityActivityView> createState() =>
      _MyCommunityActivityViewState();
}

class _MyCommunityActivityViewState extends State<MyCommunityActivityView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    widget.viewModel.load();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }
    widget.viewModel.selectTab(
      _tabController.index == 0
          ? MyCommunityActivityTab.posts
          : MyCommunityActivityTab.comments,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openPost(String postId) {
    context.push(AppRoute.communityPostPath(postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 커뮤니티 활동'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: MyTheme.primary,
          labelColor: MyTheme.textPrimary,
          tabs: const [
            Tab(text: '글'),
            Tab(text: '댓글'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.tab == MyCommunityActivityTab.posts) {
            final posts = widget.viewModel.posts;
            if (posts.isEmpty) {
              return const _EmptyView(message: '아직 작성한 글이 없어요');
            }
            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  onTap: () => _openPost(post.id),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _KindChip(kind: post.kind),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          color: MyTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.timeLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: MyTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite_border, size: 14),
                      Text(' ${post.likeCount}',
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 8),
                      const Icon(Icons.chat_bubble_outline, size: 14),
                      Text(' ${post.commentCount}',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            );
          }

          final comments = widget.viewModel.comments;
          if (comments.isEmpty) {
            return const _EmptyView(message: '아직 작성한 댓글이 없어요');
          }
          return ListView.separated(
            itemCount: comments.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                onTap: () => _openPost(comment.postId),
                title: Text(
                  comment.postTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    comment.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: MyTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                trailing: Text(
                  comment.timeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: MyTheme.textSecondary,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({required this.kind});

  final CommunityPostKind kind;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (kind) {
      CommunityPostKind.thread => ('스레드', MyTheme.primary),
      CommunityPostKind.userMission => ('유저미션', Color(0xFF7C4DFF)),
      CommunityPostKind.userPoll => ('유저투표', Color(0xFFFF6F61)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PicktorySpacing.xl),
        child: Text(
          message,
          style: const TextStyle(color: MyTheme.textSecondary),
        ),
      ),
    );
  }
}

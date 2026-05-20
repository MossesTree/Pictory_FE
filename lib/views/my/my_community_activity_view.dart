import 'package:flutter/material.dart';
import 'package:picktory/viewmodels/my_community_activity_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 커뮤니티 활동'),
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
            return ListView.separated(
                itemCount: widget.viewModel.posts.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final post = widget.viewModel.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.timeLabel),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_border, size: 16),
                        Text(' ${post.likeCount}'),
                        const SizedBox(width: 8),
                        const Icon(Icons.chat_bubble_outline, size: 16),
                        Text(' ${post.commentCount}'),
                      ],
                    ),
                  );
                },
              );
          }

          return ListView.separated(
            itemCount: widget.viewModel.comments.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final comment = widget.viewModel.comments[index];
              return ListTile(
                title: Text(comment.postTitle),
                subtitle: Text(comment.content),
                trailing: Text(comment.timeLabel),
              );
            },
          );
        },
      ),
    );
  }
}

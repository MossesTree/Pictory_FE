import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/viewmodels/community_feed_view_model.dart';
import 'package:picktory/views/community/widgets/community_action_sheet.dart';
import 'package:picktory/views/community/widgets/community_post_card.dart';
import 'package:picktory/views/community/widgets/user_mission_card.dart';

class CommunityFeedView extends StatefulWidget {
  const CommunityFeedView({super.key, required this.viewModel});

  final CommunityFeedViewModel viewModel;

  @override
  State<CommunityFeedView> createState() => _CommunityFeedViewState();
}

class _CommunityFeedViewState extends State<CommunityFeedView>
    with RouteAware, SingleTickerProviderStateMixin {
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
          ? CommunityFeedTab.thread
          : CommunityFeedTab.userMission,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<void>) {
      AppRouter.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    widget.viewModel.refresh();
  }

  Future<void> _openCreateSheet() async {
    final action = await showCommunityCreateSheet(context);
    if (!mounted || action == null) {
      return;
    }
    if (action == 'compose') {
      await context.push(AppRoute.communityCompose.path);
    } else if (action == 'suggest') {
      await context.push(AppRoute.communityMissionSuggest.path);
    }
    widget.viewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Stack(
            children: [
              Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: '스레드'),
                      Tab(text: '유저 미션'),
                    ],
                  ),
                  if (viewModel.isRefreshing)
                    const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _ThreadTab(
                          viewModel: viewModel,
                          onPostTap: (id) => context
                              .push(AppRoute.communityPostPath(id))
                              .then((_) => viewModel.refresh()),
                          onMoreTap: _handlePostMore,
                        ),
                        _UserMissionTab(
                          viewModel: viewModel,
                          onMissionTap: (id) => context
                              .push(AppRoute.userMissionDetailPath(id))
                              .then((_) => viewModel.refresh()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: _openCreateSheet,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      );
  }

  Future<void> _handlePostMore(String postId) async {
    CommunityPost? post;
    for (final item in widget.viewModel.posts) {
      if (item.id == postId) {
        post = item;
        break;
      }
    }
    if (post == null) {
      return;
    }
    final action = await showCommunityPostActionSheet(context, post: post);
    if (!mounted || action == null) {
      return;
    }
    switch (action) {
      case CommunityPostAction.edit:
        await context.push(AppRoute.communityComposePath(editPostId: postId));
      case CommunityPostAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('삭제 확인'),
            content: const Text('게시물을 삭제할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirmed == true && mounted) {
          await ServiceLocator.instance.communityRepository.deletePost(postId);
        }
      case CommunityPostAction.report:
        await context.push(
          AppRoute.communityReportPath(
            targetType: 'post',
            targetId: postId,
          ),
        );
      case CommunityPostAction.block:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('유저를 차단했습니다.')),
        );
      case CommunityPostAction.share:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('딥링크가 클립보드에 복사되었습니다.')),
        );
    }
    widget.viewModel.refresh();
  }
}

class _ThreadTab extends StatelessWidget {
  const _ThreadTab({
    required this.viewModel,
    required this.onPostTap,
    required this.onMoreTap,
  });

  final CommunityFeedViewModel viewModel;
  final ValueChanged<String> onPostTap;
  final ValueChanged<String> onMoreTap;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && viewModel.posts.isEmpty) {
      return Center(child: Text(viewModel.errorMessage!));
    }
    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: viewModel.posts.length,
        itemBuilder: (context, index) {
          final post = viewModel.posts[index];
          return CommunityPostCard(
            post: post,
            onTap: () => onPostTap(post.id),
            onMoreTap: () => onMoreTap(post.id),
          );
        },
      ),
    );
  }
}

class _UserMissionTab extends StatelessWidget {
  const _UserMissionTab({
    required this.viewModel,
    required this.onMissionTap,
  });

  final CommunityFeedViewModel viewModel;
  final ValueChanged<String> onMissionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: UserMissionFilter.values.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_filterLabel(filter)),
                  selected: viewModel.filter == filter,
                  onSelected: (_) => viewModel.selectFilter(filter),
                ),
              );
            }).toList(),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: UserMissionSort.values.map((sort) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_sortLabel(sort)),
                  selected: viewModel.sort == sort,
                  onSelected: (_) => viewModel.selectSort(sort),
                ),
              );
            }).toList(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => context.push(AppRoute.userMissionCreate.path),
            icon: const Icon(Icons.add),
            label: const Text('유저 미션 올리기'),
          ),
        ),
        Expanded(
          child: viewModel.isLoading && viewModel.userMissions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: viewModel.refresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: viewModel.userMissions.length,
                    itemBuilder: (context, index) {
                      final mission = viewModel.userMissions[index];
                      return UserMissionCard(
                        mission: mission,
                        onTap: () => onMissionTap(mission.id),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  String _filterLabel(UserMissionFilter filter) => switch (filter) {
        UserMissionFilter.all => '전체',
        UserMissionFilter.active => '진행중',
        UserMissionFilter.closed => '마감',
        UserMissionFilter.mine => '내 미션',
      };

  String _sortLabel(UserMissionSort sort) => switch (sort) {
        UserMissionSort.latest => '최신순',
        UserMissionSort.popular => '인기순',
        UserMissionSort.participants => '참여순',
        UserMissionSort.views => '조회순',
      };
}

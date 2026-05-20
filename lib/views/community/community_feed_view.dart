import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/viewmodels/community_feed_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';
import 'package:picktory/views/community/widgets/community_action_sheet.dart';
import 'package:picktory/views/community/widgets/community_category_carousel.dart';
import 'package:picktory/views/community/widgets/community_main_tabs.dart';
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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabIndexChanged);
    widget.viewModel.load();
  }

  void _onTabIndexChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }
    widget.viewModel.selectTab(CommunityFeedTab.values[_tabController.index]);
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

    return ColoredBox(
      color: CommunityTheme.background,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                      child: Row(
                        children: [
                          const Text(
                            '커뮤니티',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                    CommunityMainTabs(controller: _tabController),
                    if (viewModel.isRefreshing)
                      const LinearProgressIndicator(
                        minHeight: 2,
                        color: CommunityTheme.yellow,
                      ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _PostFeedTab(
                            viewModel: viewModel,
                            onPostTap: _openPost,
                            onMoreTap: _handlePostMore,
                          ),
                          _PostFeedTab(
                            viewModel: viewModel,
                            showCategoryCarousel: true,
                            onPostTap: _openPost,
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
                    backgroundColor: CommunityTheme.fab,
                    foregroundColor: Colors.white,
                    onPressed: _openCreateSheet,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openPost(String id) async {
    await context.push(AppRoute.communityPostPath(id));
    widget.viewModel.refresh();
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
        await ServiceLocator.instance.communityRepository
            .blockUser(post.authorNickname);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('유저를 차단했습니다.')),
          );
        }
      case CommunityPostAction.share:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('딥링크가 클립보드에 복사되었습니다.')),
        );
    }
    widget.viewModel.refresh();
  }
}

class _PostFeedTab extends StatelessWidget {
  const _PostFeedTab({
    required this.viewModel,
    required this.onPostTap,
    required this.onMoreTap,
    this.showCategoryCarousel = false,
  });

  final CommunityFeedViewModel viewModel;
  final ValueChanged<String> onPostTap;
  final ValueChanged<String> onMoreTap;
  final bool showCategoryCarousel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && viewModel.posts.isEmpty) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    return RefreshIndicator(
      color: CommunityTheme.yellow,
      onRefresh: viewModel.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (showCategoryCarousel && viewModel.categories.isNotEmpty)
            SliverToBoxAdapter(
              child: CommunityCategoryCarousel(
                categories: viewModel.categories,
                selectedId: viewModel.categoryId,
                onSelected: viewModel.selectCategory,
              ),
            ),
          if (viewModel.posts.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('게시물이 없습니다')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = viewModel.posts[index];
                  return CommunityPostCard(
                    post: post,
                    onTap: () => onPostTap(post.id),
                    onMoreTap: () => onMoreTap(post.id),
                    onVoteTap: post.hasPoll ? () => onPostTap(post.id) : null,
                  );
                },
                childCount: viewModel.posts.length,
              ),
            ),
        ],
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
                child: FilterChip(
                  label: Text(_filterLabel(filter)),
                  selected: viewModel.filter == filter,
                  selectedColor: CommunityTheme.yellow,
                  onSelected: (_) => viewModel.selectFilter(filter),
                ),
              );
            }).toList(),
          ),
        ),
        if (viewModel.categories.isNotEmpty)
          CommunityCategoryCarousel(
            categories: viewModel.categories,
            selectedId: viewModel.categoryId,
            onSelected: viewModel.selectCategory,
          ),
        Expanded(
          child: viewModel.isLoading && viewModel.userMissions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  color: CommunityTheme.yellow,
                  onRefresh: viewModel.refresh,
                  child: viewModel.userMissions.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('유저 미션이 없습니다')),
                          ],
                        )
                      : ListView.builder(
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
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/services/dummy/dummy_community_data.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/views/home/home_theme.dart';

/// IA H-1 검색 모달 (홈·커뮤니티 헤더 공용)
/// - 더미 미션 + 더미 게시물에서 통합 검색
/// - 미션 탭 → `/mission/:id`, 스레드 탭 → `/community/post/:id`
class PicktorySearchSheet {
  PicktorySearchSheet._();

  static Future<void> show(
    BuildContext context, {
    String placeholder = '프로그램, 미션 검색...',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (sheetContext) {
        return _PicktorySearchSheetBody(placeholder: placeholder);
      },
    );
  }
}

class _PicktorySearchSheetBody extends StatefulWidget {
  const _PicktorySearchSheetBody({required this.placeholder});

  final String placeholder;

  @override
  State<_PicktorySearchSheetBody> createState() =>
      _PicktorySearchSheetBodyState();
}

class _PicktorySearchSheetBodyState extends State<_PicktorySearchSheetBody> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String _query = '';

  static const List<String> _recentKeywords = <String>[
    '환승연애4',
    '나는솔로',
    '프로듀스101',
    '흑백요리사',
  ];

  late final List<Mission> _allMissions = <Mission>[
    ...DummyDataProvider.heroMissions,
    ...DummyDataProvider.activeMissions,
  ];

  late final List<CommunityPost> _allPosts = DummyCommunityData.posts;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Mission> get _matchedMissions {
    if (_query.isEmpty) {
      return const [];
    }
    final q = _query.toLowerCase();
    return _allMissions
        .where((m) =>
            m.title.toLowerCase().contains(q) ||
            m.programLabel.toLowerCase().contains(q))
        .take(5)
        .toList();
  }

  List<CommunityPost> get _matchedPosts {
    if (_query.isEmpty) {
      return const [];
    }
    final q = _query.toLowerCase();
    return _allPosts
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.programLabel.toLowerCase().contains(q))
        .take(5)
        .toList();
  }

  void _openMission(String id) {
    Navigator.of(context).pop();
    context.push(AppRoute.missionDetailPath(id));
  }

  void _openPost(String id) {
    Navigator.of(context).pop();
    context.push(AppRoute.communityPostPath(id));
  }

  void _applyKeyword(String keyword) {
    _controller.text = keyword;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: keyword.length),
    );
    setState(() {
      _query = keyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final mediaSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        height: mediaSize.height * 0.85,
        decoration: const BoxDecoration(
          color: HomeTheme.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _SearchHeader(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: widget.placeholder,
                onChanged: (value) => setState(() => _query = value),
                onClose: () => Navigator.of(context).pop(),
              ),
              const Divider(height: 1),
              Expanded(
                child: _query.isEmpty
                    ? _RecentList(
                        keywords: _recentKeywords,
                        onSelect: _applyKeyword,
                      )
                    : _ResultList(
                        missions: _matchedMissions,
                        posts: _matchedPosts,
                        onMissionTap: _openMission,
                        onPostTap: _openPost,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.onChanged,
    required this.onClose,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: HomeTheme.textPrimary,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: HomeTheme.textTertiary,
                  fontSize: 14,
                ),
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                filled: true,
                fillColor: HomeTheme.surface,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: HomeTheme.textTertiary,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList({required this.keywords, required this.onSelect});

  final List<String> keywords;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const Text(
          '추천 검색어',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: HomeTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: keywords
              .map(
                (k) => ActionChip(
                  label: Text(k),
                  backgroundColor: HomeTheme.surface,
                  side: BorderSide(color: HomeTheme.border),
                  onPressed: () => onSelect(k),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({
    required this.missions,
    required this.posts,
    required this.onMissionTap,
    required this.onPostTap,
  });

  final List<Mission> missions;
  final List<CommunityPost> posts;
  final ValueChanged<String> onMissionTap;
  final ValueChanged<String> onPostTap;

  @override
  Widget build(BuildContext context) {
    final empty = missions.isEmpty && posts.isEmpty;
    if (empty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            '검색 결과가 없습니다',
            style: TextStyle(color: HomeTheme.textSecondary),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (missions.isNotEmpty) ...[
          const _SectionLabel('미션'),
          const SizedBox(height: 8),
          ...missions.map(
            (m) => _ResultTile(
              icon: Icons.emoji_events_outlined,
              title: m.title,
              subtitle: m.programLabel,
              onTap: () => onMissionTap(m.id),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (posts.isNotEmpty) ...[
          const _SectionLabel('스레드'),
          const SizedBox(height: 8),
          ...posts.map(
            (p) => _ResultTile(
              icon: Icons.forum_outlined,
              title: p.title,
              subtitle: p.programLabel,
              onTap: () => onPostTap(p.id),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: HomeTheme.textPrimary,
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: HomeTheme.primaryPurple),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HomeTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: HomeTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: HomeTheme.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

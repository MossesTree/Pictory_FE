import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/notification_settings_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

/// IA S-2 알림 설정 — Figma 840:1718 4 그룹 카드
class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key, required this.viewModel});

  final NotificationSettingsViewModel viewModel;

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      appBar: AppBar(
        title: const Text(
          '알림 설정',
          style: TextStyle(
            color: MyTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: MyTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: MyTheme.textPrimary,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final s = widget.viewModel.settings;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const _SectionLabel('픽 & 미션'),
              _SwitchGroup(items: [
                _SwitchRow(
                  title: '미션 결과 알림',
                  value: s.missionResult,
                  onChanged: widget.viewModel.setMissionResult,
                ),
                _SwitchRow(
                  title: '포인트 지급 알림',
                  value: s.pointReward,
                  onChanged: widget.viewModel.setPointReward,
                ),
                _SwitchRow(
                  title: '관심 프로그램 알림',
                  value: s.interestedProgram,
                  onChanged: widget.viewModel.setInterestedProgram,
                ),
              ]),
              const _SectionLabel('커뮤니티'),
              _SwitchGroup(items: [
                _SwitchRow(
                  title: '댓글 알림',
                  value: s.comment,
                  onChanged: widget.viewModel.setComment,
                ),
                _SwitchRow(
                  title: '좋아요 알림',
                  value: s.like,
                  onChanged: widget.viewModel.setLike,
                ),
              ]),
              const _SectionLabel('설정 & 랭킹'),
              _SwitchGroup(items: [
                _SwitchRow(
                  title: '랭킹 단계 변화 알림',
                  value: s.rankingChange,
                  onChanged: widget.viewModel.setRankingChange,
                ),
                _SwitchRow(
                  title: '스페셜 뱃지 획득 알림',
                  value: s.specialBadge,
                  onChanged: widget.viewModel.setSpecialBadge,
                ),
                _SwitchRow(
                  title: '성장 뱃지 레벨업 알림',
                  value: s.growthBadgeLevelUp,
                  onChanged: widget.viewModel.setGrowthBadgeLevelUp,
                ),
              ]),
              const _SectionLabel('서비스'),
              _SwitchGroup(items: [
                _SwitchRow(
                  title: '이벤트 · 공지 알림',
                  value: s.eventNotice,
                  onChanged: widget.viewModel.setEventNotice,
                ),
                _SwitchRow(
                  title: '업데이트 알림',
                  value: s.appUpdate,
                  onChanged: widget.viewModel.setAppUpdate,
                ),
              ]),
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 0, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: MyTheme.sectionLabel,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SwitchGroup extends StatelessWidget {
  const _SwitchGroup({required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      rows.add(items[i]);
      if (i != items.length - 1) {
        rows.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: MyTheme.border),
        ));
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: rows),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: MyTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: MyTheme.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD0CCDB),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

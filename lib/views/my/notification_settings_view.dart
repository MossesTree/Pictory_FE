import 'package:flutter/material.dart';
import 'package:picktory/viewmodels/notification_settings_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

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
      appBar: AppBar(title: const Text('알림 설정')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final s = widget.viewModel.settings;

          return ListView(
            children: [
              const _SectionHeader('픽 & 미션'),
              _SettingSwitch(
                title: '미션 결과 알림',
                value: s.missionResult,
                onChanged: widget.viewModel.setMissionResult,
              ),
              _SettingSwitch(
                title: '포인트 지급 알림',
                value: s.pointReward,
                onChanged: widget.viewModel.setPointReward,
              ),
              _SettingSwitch(
                title: '관심 프로그램 알림',
                value: s.interestedProgram,
                onChanged: widget.viewModel.setInterestedProgram,
              ),
              const _SectionHeader('커뮤니티'),
              _SettingSwitch(
                title: '댓글 알림',
                value: s.comment,
                onChanged: widget.viewModel.setComment,
              ),
              _SettingSwitch(
                title: '좋아요 알림',
                value: s.like,
                onChanged: widget.viewModel.setLike,
              ),
              const _SectionHeader('성장 & 랭킹'),
              _SettingSwitch(
                title: '랭킹 단계 변화 알림',
                value: s.rankingChange,
                onChanged: widget.viewModel.setRankingChange,
              ),
              _SettingSwitch(
                title: '스페셜 뱃지 획득 알림',
                value: s.specialBadge,
                onChanged: widget.viewModel.setSpecialBadge,
              ),
              _SettingSwitch(
                title: '성장 뱃지 레벨업 알림',
                value: s.growthBadgeLevelUp,
                onChanged: widget.viewModel.setGrowthBadgeLevelUp,
              ),
              const _SectionHeader('서비스'),
              _SettingSwitch(
                title: '이벤트 · 공지 알림',
                value: s.eventNotice,
                onChanged: widget.viewModel.setEventNotice,
              ),
              _SettingSwitch(
                title: '업데이트 알림',
                value: s.appUpdate,
                onChanged: widget.viewModel.setAppUpdate,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: MyTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      activeThumbColor: MyTheme.primary,
      activeTrackColor: MyTheme.primary.withValues(alpha: 0.4),
      onChanged: onChanged,
    );
  }
}

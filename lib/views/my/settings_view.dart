import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/auth_session.dart';
import 'package:picktory/views/my/my_theme.dart';

/// IA S-1 환경설정 메인
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  /// IA S-1 앱 버전 표시 — Phase 5에서 package_info_plus 로 교체
  static const String _appVersion = 'v1.0.0';

  SocialProvider? _provider;
  bool _loadingSession = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session =
        await ServiceLocator.instance.authRepository.getSession();
    if (!mounted) return;
    setState(() {
      _provider = session?.socialProvider;
      _loadingSession = false;
    });
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃 하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    await ServiceLocator.instance.authRepository.clearSession();
    if (mounted) {
      context.go(AppRoute.login.path);
    }
  }

  /// IA S-1 계정 탈퇴: 2단계 확인 후 삭제 → 로그인 화면 이동
  Future<void> _confirmWithdraw() async {
    final firstOk = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('계정 탈퇴'),
        content: const Text(
          '탈퇴하시면 모든 활동 내역과 보유한 Pick·뱃지가 삭제되며 복구할 수 없습니다. 계속하시겠어요?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: MyTheme.danger),
            child: const Text('계속'),
          ),
        ],
      ),
    );
    if (!mounted || firstOk != true) return;

    final secondOk = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('정말로 탈퇴하시겠어요?'),
        content: const Text(
          '이 작업은 되돌릴 수 없습니다.\n탈퇴를 진행하려면 "탈퇴"를 눌러주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: MyTheme.danger),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );
    if (!mounted || secondOk != true) return;
    await ServiceLocator.instance.authRepository.clearSession();
    if (mounted) {
      context.go(AppRoute.login.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      appBar: AppBar(
        title: const Text(
          '환경설정',
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
      body: _loadingSession
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                PicktorySpacing.md,
                PicktorySpacing.sm,
                PicktorySpacing.md,
                PicktorySpacing.xl,
              ),
              children: [
                _SectionLabel('계정'),
                _GroupCard(children: [
                  _Tile(
                    title: '연결 계정',
                    trailing: Text(
                      _provider == null
                          ? '연결 안 됨'
                          : '${_provider!.displayLabel} 로그인',
                      style: const TextStyle(
                        color: MyTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]),
                _SectionLabel('알림'),
                _GroupCard(children: [
                  _Tile(
                    title: '알림 설정',
                    showChevron: true,
                    onTap: () =>
                        context.push(AppRoute.notificationSettings.path),
                  ),
                ]),
                _SectionLabel('고객지원'),
                _GroupCard(children: [
                  _Tile(
                    title: '공지사항',
                    showChevron: true,
                    onTap: () => context.push(AppRoute.settingsNotices.path),
                  ),
                  _Tile(
                    title: '문의하기',
                    showChevron: true,
                    onTap: () => context.push(AppRoute.settingsInquiry.path),
                  ),
                ]),
                _SectionLabel('약관 및 기타'),
                _GroupCard(children: [
                  _Tile(
                    title: '서비스 이용약관',
                    showChevron: true,
                    onTap: () => context.push(AppRoute.settingsTerms.path),
                  ),
                  _Tile(
                    title: '개인정보 처리방침',
                    showChevron: true,
                    onTap: () => context.push(AppRoute.settingsPrivacy.path),
                  ),
                  _Tile(
                    title: '앱 버전',
                    trailing: const Text(
                      _appVersion,
                      style: TextStyle(
                        color: MyTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                _GroupCard(children: [
                  _Tile(
                    title: '계정 탈퇴',
                    titleColor: MyTheme.danger,
                    titleWeight: FontWeight.w700,
                    onTap: _confirmWithdraw,
                  ),
                  _Tile(title: '로그아웃', onTap: _confirmLogout),
                ]),
              ],
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

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
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

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    this.onTap,
    this.trailing,
    this.showChevron = false,
    this.titleColor = MyTheme.textPrimary,
    this.titleWeight = FontWeight.w500,
  });

  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;
  final Color titleColor;
  final FontWeight titleWeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: titleWeight,
                  ),
                ),
              ),
              ?trailing,
              if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: MyTheme.textTertiary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

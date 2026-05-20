import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/views/my/my_theme.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('환경설정')),
      body: ListView(
        children: [
          const _SectionHeader('계정'),
          const ListTile(
            title: Text('연결 계정'),
            trailing: Text('카카오 로그인'),
          ),
          const Divider(height: 1),
          const _SectionHeader('알림'),
          ListTile(
            title: const Text('알림 설정'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoute.notificationSettings.path),
          ),
          const Divider(height: 1),
          const _SectionHeader('고객지원'),
          ListTile(
            title: const Text('공지사항'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('문의하기'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          const _SectionHeader('약관 및 기타'),
          ListTile(
            title: const Text('서비스 이용약관'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('개인정보 처리방침'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const ListTile(
            title: Text('앱 버전'),
            trailing: Text('v1.0.0'),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text(
              '계정 탈퇴',
              style: TextStyle(color: MyTheme.danger),
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () async {
              await ServiceLocator.instance.authRepository.clearSession();
              if (context.mounted) {
                context.go(AppRoute.login.path);
              }
            },
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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

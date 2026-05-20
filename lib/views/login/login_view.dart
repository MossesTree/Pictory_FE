import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/login_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  Future<void> _goAfterAuth(BuildContext context, {required bool completed}) async {
    if (!context.mounted) {
      return;
    }
    if (completed) {
      context.go(AppRoute.home.path);
    } else {
      context.go(AppRoute.signupTerms.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeLoginBody(
          viewModel: viewModel,
          onEmailLogin: () async {
            final ok = await viewModel.signInWithEmail();
            if (!context.mounted || !ok) {
              return;
            }
            await _goAfterAuth(context, completed: true);
          },
          onSocialLogin: (provider) async {
            final session = await viewModel.signInWithSocial(provider);
            if (!context.mounted || session == null) {
              return;
            }
            await _goAfterAuth(
              context,
              completed: session.isOnboardingCompleted,
            );
          },
          onSignUp: () => context.go(AppRoute.signupTerms.path),
          onFindId: () => context.push(AppRoute.findId.path),
          onResetPassword: () => context.push(AppRoute.resetPassword.path),
        );
      },
    );
  }
}

class WireframeLoginBody extends StatelessWidget {
  const WireframeLoginBody({
    super.key,
    required this.viewModel,
    required this.onEmailLogin,
    required this.onSocialLogin,
    required this.onSignUp,
    required this.onFindId,
    required this.onResetPassword,
  });

  final LoginViewModel viewModel;
  final VoidCallback onEmailLogin;
  final Future<void> Function(String provider) onSocialLogin;
  final VoidCallback onSignUp;
  final VoidCallback onFindId;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Text('LOGO'),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: '이메일',
                  hintText: 'example@email.com',
                ),
                onChanged: viewModel.updateEmail,
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  hintText: '••••••••',
                ),
                onChanged: viewModel.updatePassword,
              ),
              if (viewModel.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              WireframeButton(
                label: viewModel.isSubmitting ? '로그인 중...' : '로그인',
                enabled: viewModel.canLogin,
                onPressed: onEmailLogin,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onFindId,
                child: const Text('아이디 찾기 · 비밀번호 찾기'),
              ),
              const SizedBox(height: 16),
              const Text('또는'),
              const SizedBox(height: 16),
              _SocialButton(
                label: 'Google',
                badge: viewModel.recentProvider == 'google' ? '최근' : null,
                onPressed: () => onSocialLogin('google'),
              ),
              const SizedBox(height: 8),
              _SocialButton(
                label: 'Apple',
                badge: viewModel.recentProvider == 'apple' ? '최근' : null,
                onPressed: () => onSocialLogin('apple'),
              ),
              const SizedBox(height: 8),
              _SocialButton(
                label: 'Kakao',
                badge: viewModel.recentProvider == 'kakao' ? '최근' : null,
                onPressed: () => onSocialLogin('kakao'),
              ),
              const SizedBox(height: 24),
              WireframeButton(
                label: '간편 회원가입하기',
                onPressed: onSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.onPressed,
    this.badge,
  });

  final String label;
  final String? badge;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badge!, style: const TextStyle(fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }
}

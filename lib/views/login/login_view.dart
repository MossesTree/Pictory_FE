import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/login_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_primary_button.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_social_button.dart';

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
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'LOGO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: OnboardingTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OnboardingSocialButton(
                        label: 'Kakao',
                        backgroundColor: OnboardingTheme.yellow,
                        foregroundColor: OnboardingTheme.black,
                        icon: const Icon(Icons.chat_bubble, color: Colors.black),
                        onPressed: viewModel.isSubmitting
                            ? () {}
                            : () => _socialLogin(context, 'kakao'),
                      ),
                      const SizedBox(width: 24),
                      OnboardingSocialButton(
                        label: 'Google',
                        backgroundColor: Colors.white,
                        foregroundColor: OnboardingTheme.black,
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        onPressed: viewModel.isSubmitting
                            ? () {}
                            : () => _socialLogin(context, 'google'),
                      ),
                      const SizedBox(width: 24),
                      OnboardingSocialButton(
                        label: 'Apple',
                        backgroundColor: OnboardingTheme.black,
                        foregroundColor: Colors.white,
                        icon: const Icon(Icons.apple, color: Colors.white),
                        onPressed: viewModel.isSubmitting
                            ? () {}
                            : () => _socialLogin(context, 'apple'),
                      ),
                    ],
                  ),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const Spacer(),
                  OnboardingPrimaryButton(
                    label: viewModel.isSubmitting ? '로그인 중...' : '로그인',
                    enabled: !viewModel.isSubmitting,
                    onPressed: () => _socialLogin(context, 'kakao'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(AppRoute.signupTerms.path),
                    child: const Text('가입'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _socialLogin(BuildContext context, String provider) async {
    final session = await viewModel.signInWithSocial(provider);
    if (!context.mounted || session == null) {
      return;
    }
    await _goAfterAuth(
      context,
      completed: session.isOnboardingCompleted,
    );
  }
}

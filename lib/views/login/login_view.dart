import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/viewmodels/login_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';

/// IA O-2 소셜 로그인 화면
/// - 카카오/구글/애플 각 "OO로 계속하기" 와이드 버튼
/// - 신규 → 약관 동의 / 기존 → 홈
class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  Future<void> _goAfterAuth(
    BuildContext context, {
    required bool completed,
  }) async {
    if (!context.mounted) {
      return;
    }
    if (completed) {
      context.go(AppRoute.home.path);
    } else {
      context.go(AppRoute.signupTerms.path);
    }
  }

  Future<void> _socialLogin(BuildContext context, String provider) async {
    final session = await viewModel.signInWithSocial(provider);
    if (!context.mounted || session == null) {
      return;
    }
    await _goAfterAuth(context, completed: session.isOnboardingCompleted);
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
              padding: const EdgeInsets.all(PicktorySpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: OnboardingTheme.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 44,
                        color: OnboardingTheme.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: PicktorySpacing.md),
                  const Center(
                    child: Text(
                      '픽토리',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Pick Your Story',
                      style: TextStyle(
                        fontSize: 13,
                        color: OnboardingTheme.textSecondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _SocialWideButton(
                    label: '카카오로 계속하기',
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: OnboardingTheme.black,
                    icon: const Icon(Icons.chat_bubble, color: Colors.black87),
                    isLoading: viewModel.isSubmitting,
                    onPressed: () => _socialLogin(context, 'kakao'),
                  ),
                  const SizedBox(height: PicktorySpacing.sm),
                  _SocialWideButton(
                    label: '구글로 계속하기',
                    backgroundColor: Colors.white,
                    foregroundColor: OnboardingTheme.black,
                    border: BorderSide(color: Colors.grey.shade300),
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    isLoading: viewModel.isSubmitting,
                    onPressed: () => _socialLogin(context, 'google'),
                  ),
                  const SizedBox(height: PicktorySpacing.sm),
                  _SocialWideButton(
                    label: '애플로 계속하기',
                    backgroundColor: OnboardingTheme.black,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.apple, color: Colors.white),
                    isLoading: viewModel.isSubmitting,
                    onPressed: () => _socialLogin(context, 'apple'),
                  ),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: PicktorySpacing.sm),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: PicktorySpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SocialWideButton extends StatelessWidget {
  const _SocialWideButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.onPressed,
    required this.isLoading,
    this.border,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: border ?? BorderSide.none,
        ),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(width: 24, child: Center(child: icon)),
                    Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: foregroundColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

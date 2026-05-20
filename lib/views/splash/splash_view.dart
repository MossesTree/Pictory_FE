import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/splash_destination.dart';
import 'package:picktory/viewmodels/splash_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, required this.viewModel});

  final SplashViewModel viewModel;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final destination = await widget.viewModel.resolveDestination();
    if (!mounted) {
      return;
    }

    switch (destination) {
      case SplashDestination.home:
        context.go(AppRoute.home.path);
      case SplashDestination.signup:
        context.go(AppRoute.signupTerms.path);
      case SplashDestination.login:
        context.go(AppRoute.login.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 88,
                    height: 88,
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
                  const SizedBox(height: 20),
                  Text(
                    viewModel.appName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    viewModel.tagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: OnboardingTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    viewModel.loadingLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: OnboardingTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _LoadingDots(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

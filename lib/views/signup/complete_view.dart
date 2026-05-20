import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/onboarding_complete_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_primary_button.dart';

class OnboardingCompleteView extends StatefulWidget {
  const OnboardingCompleteView({super.key, required this.viewModel});

  final OnboardingCompleteViewModel viewModel;

  @override
  State<OnboardingCompleteView> createState() => _OnboardingCompleteViewState();
}

class _OnboardingCompleteViewState extends State<OnboardingCompleteView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 20),
                  Text(
                    viewModel.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: OnboardingTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _CoinCard(
                          amount: '${viewModel.baseCoins}',
                          label: '가입 보상',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('+', style: TextStyle(fontSize: 20)),
                      ),
                      Expanded(
                        child: _CoinCard(
                          amount: viewModel.bonusCoins > 0
                              ? '+${viewModel.bonusCoins}'
                              : '+0',
                          label: '초대코드 보너스',
                          highlight: viewModel.bonusCoins > 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '총 ${viewModel.totalCoins}코인 지급 완료! 🎁',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  OnboardingPrimaryButton(
                    label: viewModel.isCompleting ? '처리 중...' : '미션 시작하기',
                    enabled: !viewModel.isCompleting,
                    onPressed: () async {
                      final ok = await viewModel.completeOnboarding();
                      if (!context.mounted || !ok) {
                        return;
                      }
                      context.go(AppRoute.home.path);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CoinCard extends StatelessWidget {
  const _CoinCard({
    required this.amount,
    required this.label,
    this.highlight = false,
  });

  final String amount;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: highlight
            ? OnboardingTheme.yellow.withValues(alpha: 0.4)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight ? OnboardingTheme.yellow : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

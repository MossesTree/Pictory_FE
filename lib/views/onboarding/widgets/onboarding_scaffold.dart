import 'package:flutter/material.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.topTrailing,
    this.bottom,
    this.showBackButton = false,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? topTrailing;
  final Widget? bottom;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: const SizedBox.shrink(),
        actions: topTrailing != null ? [topTrailing!] : null,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: OnboardingTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(child: body),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: bottom!,
              ),
          ],
        ),
      ),
    );
  }
}

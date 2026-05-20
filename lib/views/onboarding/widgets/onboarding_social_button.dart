import 'package:flutter/material.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';

class OnboardingSocialButton extends StatelessWidget {
  const OnboardingSocialButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: backgroundColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: icon ??
                    Text(
                      label[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: foregroundColor,
                        fontSize: 18,
                      ),
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: OnboardingTheme.textSecondary),
        ),
      ],
    );
  }
}

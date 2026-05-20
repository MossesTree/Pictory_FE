import 'package:flutter/material.dart';

class WireframeButton extends StatelessWidget {
  const WireframeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.expandWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool expandWidth;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: Text(label),
      ),
    );

    if (!expandWidth) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}

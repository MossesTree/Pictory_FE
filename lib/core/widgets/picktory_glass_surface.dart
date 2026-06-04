import 'dart:ui';

import 'package:flutter/material.dart';

/// 글래스모피즘 표면 — 플로팅 탭바·패널 등 재사용
class PicktoryGlassSurface extends StatelessWidget {
  const PicktoryGlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.blurSigma = 32,
    this.tintColor = const Color(0xCCFFFFFF),
    this.tintColorEnd,
    this.borderColor = const Color(0xF2FFFFFF),
    this.shadowColor = const Color(0x338F6BFF),
    this.specularColor = const Color(0x99FFFFFF),
    this.height,
    this.padding,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color tintColor;
  final Color? tintColorEnd;
  final Color borderColor;
  final Color shadowColor;
  final Color specularColor;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  tintColor,
                  tintColorEnd ?? tintColor.withValues(alpha: 0.82),
                ],
              ),
              border: Border.all(color: borderColor, width: 1.2),
            ),
            child: Stack(
              children: [
                // 상단 하이라이트 (유리 반사)
                Positioned(
                  top: 0,
                  left: 12,
                  right: 12,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          specularColor,
                          specularColor.withValues(alpha: 0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

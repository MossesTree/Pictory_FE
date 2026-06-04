import 'package:flutter/material.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/mission_theme.dart';

/// 폼 섹션 라벨 (Figma M-5 / M-4 — 주황 필수 점)
class MissionFormSectionLabel extends StatelessWidget {
  const MissionFormSectionLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: MissionTheme.textPrimary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFFF8A50),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

/// 카테고리 칩 (Figma 연애예능 스타일)
class MissionCategoryChips extends StatelessWidget {
  const MissionCategoryChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selected;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(option),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? MissionTheme.badgeFill
                    : MissionTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? MissionTheme.primary : MissionTheme.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? MissionTheme.primary
                      : MissionTheme.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 아웃라인 입력 필드
class MissionOutlineTextField extends StatelessWidget {
  const MissionOutlineTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.counterText,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int? maxLength;
  final String? counterText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(
        color: MissionTheme.textPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: MissionTheme.textTertiary),
        filled: true,
        fillColor: MissionTheme.surface,
        suffixIcon: suffixIcon,
        counterText: counterText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MissionTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MissionTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MissionTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

/// 선택지 추가 버튼 (Figma — 보라 + 아이콘 전체 너비)
class MissionAddChoiceButton extends StatelessWidget {
  const MissionAddChoiceButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: MissionTheme.primary.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_rounded, color: MissionTheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// 스레드 공유 상단 미션 카드 (Figma 549:1338 그라데이션)
class MissionShareHeroCard extends StatelessWidget {
  const MissionShareHeroCard({super.key, required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: HomeTheme.heroGradient,
        borderRadius: BorderRadius.circular(HomeTheme.heroCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HomeTheme.progressOrange,
                    width: 1.2,
                  ),
                ),
                child: const Text(
                  '진행중',
                  style: TextStyle(
                    color: HomeTheme.progressOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: HomeTheme.heroPointPill,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '+${mission.pointCost}P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            mission.programLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mission.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 4),
              Text(
                '마감까지 ${mission.remainingLabel}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 하단 고정 CTA — 비활성/부분/활성 (Figma 건의·공유 버튼)
class MissionFormSubmitButton extends StatelessWidget {
  const MissionFormSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = false,
    this.partial = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool partial;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    if (enabled) {
      bg = MissionTheme.primary;
      fg = Colors.white;
    } else if (partial) {
      bg = MissionTheme.primary.withValues(alpha: 0.35);
      fg = Colors.white;
    } else {
      bg = const Color(0xFFE8E6ED);
      fg = MissionTheme.textTertiary;
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg,
          disabledForegroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

/// M-5 건의 안내 문구
class MissionSuggestTermsBox extends StatelessWidget {
  const MissionSuggestTermsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '건의하신 미션은 검토 후 등록됩니다. 채택 시 30 Pick이 지급되며, '
      '건의자에게는 해당 미션 참여 권한이 부여됩니다.',
      style: TextStyle(
        fontSize: 11,
        color: MissionTheme.textTertiary,
        height: 1.45,
      ),
    );
  }
}

/// 폼 화면 공통 AppBar
class MissionFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MissionFormAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MissionTheme.background,
      foregroundColor: MissionTheme.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      ),
    );
  }
}

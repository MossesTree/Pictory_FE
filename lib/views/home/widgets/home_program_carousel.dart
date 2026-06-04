import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/home_program_item.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeProgramCarousel extends StatelessWidget {
  const HomeProgramCarousel({
    super.key,
    required this.programs,
    required this.selectedId,
    required this.onSelected,
  });

  final List<HomeProgramItem> programs;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.md),
        itemCount: programs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final program = programs[index];
          final isSelected = program.id == selectedId;
          return _ProgramIcon(
            program: program,
            isSelected: isSelected,
            onTap: () => onSelected(program.id),
          );
        },
      ),
    );
  }
}

class _ProgramIcon extends StatelessWidget {
  const _ProgramIcon({
    required this.program,
    required this.isSelected,
    required this.onTap,
  });

  final HomeProgramItem program;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HomeTheme.surface,
                border: Border.all(
                  color: isSelected
                      ? HomeTheme.primaryPurple
                      : HomeTheme.border,
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: HomeTheme.primaryPurple.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: program.isAll
                  ? Icon(
                      Icons.grid_view_rounded,
                      color: isSelected
                          ? HomeTheme.primaryPurple
                          : HomeTheme.textSecondary,
                      size: 24,
                    )
                  : Text(
                      program.emoji ?? '📺',
                      style: const TextStyle(fontSize: 22),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              program.displayLabel.replaceAll('\n', ' '),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? HomeTheme.primaryPurple
                    : HomeTheme.textSecondary,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

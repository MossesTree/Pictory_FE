import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/tv_program.dart';
import 'package:picktory/models/tv_program_episode.dart';
import 'package:picktory/services/tv_program_repository.dart';

/// IA M-4/M-5/C-5: 프로그램 → 회차 연결형 드롭다운 결과
class ProgramEpisodeSelection {
  const ProgramEpisodeSelection({
    required this.program,
    required this.episode,
  });

  final TvProgram program;
  final TvProgramEpisode episode;

  String get displayLabel => '${program.title} · ${episode.label}';
}

/// 칩 형태의 트리거 + 탭 시 좌(프로그램, 가나다순/검색) → 우(회차) 연결 모달
class ProgramEpisodePickerChip extends StatelessWidget {
  const ProgramEpisodePickerChip({
    super.key,
    required this.selection,
    required this.placeholder,
    required this.tvProgramRepository,
    required this.onChanged,
    this.isError = false,
  });

  final ProgramEpisodeSelection? selection;
  final String placeholder;
  final TvProgramRepository tvProgramRepository;
  final ValueChanged<ProgramEpisodeSelection> onChanged;
  final bool isError;

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<ProgramEpisodeSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProgramEpisodePickerSheet(
        tvProgramRepository: tvProgramRepository,
        initialProgramId: selection?.program.id,
      ),
    );
    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = selection != null;
    final borderColor = isError
        ? const Color(0xFFE53935)
        : (hasValue ? const Color(0xFF8F6BFF) : const Color(0xFFE0E0E0));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PicktorySpacing.md,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: hasValue ? 1.2 : 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.tv_rounded,
                size: 18,
                color: hasValue
                    ? const Color(0xFF8F6BFF)
                    : const Color(0xFF9E9E9E),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasValue ? selection!.displayLabel : placeholder,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    color: hasValue
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFF9E9E9E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.expand_more_rounded,
                color: Color(0xFF9E9E9E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma M-5/M-4 — 프로그램 · 회차 나란한 드롭다운
class ProgramEpisodePickerSplit extends StatelessWidget {
  const ProgramEpisodePickerSplit({
    super.key,
    required this.selection,
    required this.tvProgramRepository,
    required this.onChanged,
  });

  final ProgramEpisodeSelection? selection;
  final TvProgramRepository tvProgramRepository;
  final ValueChanged<ProgramEpisodeSelection> onChanged;

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<ProgramEpisodeSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProgramEpisodePickerSheet(
        tvProgramRepository: tvProgramRepository,
        initialProgramId: selection?.program.id,
      ),
    );
    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SplitBox(
            label: selection?.program.title ?? '프로그램',
            hasValue: selection != null,
            onTap: () => _open(context),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: Color(0xFFB4B0C0),
          ),
        ),
        Expanded(
          child: _SplitBox(
            label: selection?.episode.label ?? '회차',
            hasValue: selection != null,
            onTap: () => _open(context),
          ),
        ),
      ],
    );
  }
}

class _SplitBox extends StatelessWidget {
  const _SplitBox({
    required this.label,
    required this.hasValue,
    required this.onTap,
  });

  final String label;
  final bool hasValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasValue
                  ? const Color(0xFF8F6BFF)
                  : const Color(0xFFE0E0E0),
              width: hasValue ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    color: hasValue
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFF9E9E9E),
                  ),
                ),
              ),
              const Icon(
                Icons.expand_more_rounded,
                size: 18,
                color: Color(0xFF9E9E9E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramEpisodePickerSheet extends StatefulWidget {
  const _ProgramEpisodePickerSheet({
    required this.tvProgramRepository,
    this.initialProgramId,
  });

  final TvProgramRepository tvProgramRepository;
  final String? initialProgramId;

  @override
  State<_ProgramEpisodePickerSheet> createState() =>
      _ProgramEpisodePickerSheetState();
}

class _ProgramEpisodePickerSheetState
    extends State<_ProgramEpisodePickerSheet> {
  List<TvProgram> _programs = const [];
  List<TvProgramEpisode> _episodes = const [];
  TvProgram? _selectedProgram;
  bool _loadingPrograms = true;
  bool _loadingEpisodes = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    final programs = await widget.tvProgramRepository.fetchPrograms();
    programs.sort((a, b) => a.title.compareTo(b.title));
    if (!mounted) {
      return;
    }
    setState(() {
      _programs = programs;
      _loadingPrograms = false;
      if (widget.initialProgramId != null) {
        final match = programs.where(
          (p) => p.id == widget.initialProgramId,
        );
        if (match.isNotEmpty) {
          _selectedProgram = match.first;
          _loadEpisodes(match.first.id);
        }
      }
    });
  }

  Future<void> _loadEpisodes(String programId) async {
    setState(() {
      _loadingEpisodes = true;
      _episodes = const [];
    });
    final episodes = await widget.tvProgramRepository.fetchEpisodes(
      programId: programId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _episodes = episodes;
      _loadingEpisodes = false;
    });
  }

  List<TvProgram> get _filteredPrograms {
    if (_query.isEmpty) {
      return _programs;
    }
    final lower = _query.toLowerCase();
    return _programs
        .where((p) => p.title.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.all(PicktorySpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PicktorySpacing.md,
              ),
              child: Row(
                children: const [
                  Text(
                    '프로그램 · 회차 선택',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PicktorySpacing.md,
              ),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: '프로그램 검색',
                  isDense: true,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  // 좌측: 프로그램 리스트
                  Expanded(
                    flex: 5,
                    child: _loadingPrograms
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : ListView.builder(
                            itemCount: _filteredPrograms.length,
                            itemBuilder: (context, index) {
                              final program = _filteredPrograms[index];
                              final selected =
                                  _selectedProgram?.id == program.id;
                              return InkWell(
                                onTap: () {
                                  setState(() => _selectedProgram = program);
                                  _loadEpisodes(program.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: PicktorySpacing.md,
                                    vertical: 12,
                                  ),
                                  color: selected
                                      ? const Color(0xFFF3EDFF)
                                      : Colors.transparent,
                                  child: Text(
                                    program.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: selected
                                          ? const Color(0xFF8F6BFF)
                                          : const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(width: 1, color: const Color(0xFFEEEEEE)),
                  // 우측: 회차 리스트
                  Expanded(
                    flex: 5,
                    child: _selectedProgram == null
                        ? const Center(
                            child: Text(
                              '프로그램을 먼저 선택해주세요',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          )
                        : _loadingEpisodes
                            ? const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : ListView.builder(
                                itemCount: _episodes.length,
                                itemBuilder: (context, index) {
                                  final episode = _episodes[index];
                                  return InkWell(
                                    onTap: () => Navigator.of(context).pop(
                                      ProgramEpisodeSelection(
                                        program: _selectedProgram!,
                                        episode: episode,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: PicktorySpacing.md,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        episode.label,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PicktorySpacing.sm),
          ],
        ),
      ),
    );
  }
}

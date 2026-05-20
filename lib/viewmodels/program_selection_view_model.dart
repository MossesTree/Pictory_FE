import 'package:flutter/foundation.dart';
import 'package:picktory/models/tv_program.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/services/signup_repository.dart';
import 'package:picktory/services/tv_program_repository.dart';

class ProgramSelectionViewModel extends ChangeNotifier {
  ProgramSelectionViewModel({
    required SignupRepository signupRepository,
    required TvProgramRepository tvProgramRepository,
  })  : _signupRepository = signupRepository,
        _tvProgramRepository = tvProgramRepository;

  final SignupRepository _signupRepository;
  final TvProgramRepository _tvProgramRepository;

  final String title = '관심 프로그램';
  final String subtitle = '최소 1개 이상 선택해주세요';
  final List<String> categories = DummyDataProvider.programCategories;

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;
  String selectedCategory = '전체';
  String searchQuery = '';
  List<TvProgram> programs = const [];
  final Set<String> _selectedIds = {};

  Set<String> get selectedIds => Set<String>.unmodifiable(_selectedIds);
  bool get canProceed => _selectedIds.isNotEmpty && !isSaving;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final draft = await _signupRepository.loadDraft();
      _selectedIds
        ..clear()
        ..addAll(draft.selectedProgramIds);
      await _reloadPrograms();
    } catch (_) {
      errorMessage = '프로그램 목록을 불러오지 못했습니다';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(String category) async {
    selectedCategory = category;
    await _reloadPrograms();
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    await _reloadPrograms();
  }

  void toggleProgram(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  bool isSelected(String id) => _selectedIds.contains(id);

  Future<bool> saveAndProceed() async {
    if (!canProceed) {
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final draft = await _signupRepository.loadDraft();
      await _signupRepository.saveDraft(
        draft.copyWith(selectedProgramIds: _selectedIds),
      );
      return true;
    } catch (_) {
      errorMessage = '선택 저장에 실패했습니다';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _reloadPrograms() async {
    try {
      programs = await _tvProgramRepository.fetchPrograms(
        category: selectedCategory,
        query: searchQuery,
      );
    } catch (_) {
      errorMessage = '프로그램 목록을 불러오지 못했습니다';
      programs = const [];
    }
    notifyListeners();
  }
}

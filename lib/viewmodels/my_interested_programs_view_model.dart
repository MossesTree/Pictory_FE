import 'package:flutter/foundation.dart';
import 'package:picktory/models/tv_program.dart';
import 'package:picktory/services/tv_program_repository.dart';
import 'package:picktory/services/user_preference_repository.dart';

class MyInterestedProgramsViewModel extends ChangeNotifier {
  MyInterestedProgramsViewModel({
    required UserPreferenceRepository userPreferenceRepository,
    required TvProgramRepository tvProgramRepository,
  })  : _userPreferenceRepository = userPreferenceRepository,
        _tvProgramRepository = tvProgramRepository;

  final UserPreferenceRepository _userPreferenceRepository;
  final TvProgramRepository _tvProgramRepository;

  String searchQuery = '';
  List<TvProgram> searchResults = const [];
  final Map<String, TvProgram> _selectedPrograms = {};
  Set<String> _initialIds = const {};
  bool isLoading = false;
  bool isSaving = false;

  List<TvProgram> get selectedPrograms =>
      _selectedPrograms.values.toList(growable: false);

  bool get isModified {
    final currentIds = _selectedPrograms.keys.toSet();
    return currentIds.length != _initialIds.length ||
        !currentIds.containsAll(_initialIds);
  }

  bool get canSave => isModified && !isSaving;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    try {
      final preference = await _userPreferenceRepository.load();
      _initialIds = preference.selectedProgramIds;
      _selectedPrograms.clear();
      final allPrograms = await _tvProgramRepository.fetchPrograms();
      for (final id in _initialIds) {
        for (final program in allPrograms) {
          if (program.id == id) {
            _selectedPrograms[id] = program;
            break;
          }
        }
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    searchQuery = query;
    if (query.trim().isEmpty) {
      searchResults = const [];
    } else {
      searchResults = await _tvProgramRepository.fetchPrograms(query: query);
    }
    notifyListeners();
  }

  void addProgram(TvProgram program) {
    _selectedPrograms[program.id] = program;
    notifyListeners();
  }

  void removeProgram(String id) {
    _selectedPrograms.remove(id);
    notifyListeners();
  }

  bool isSelected(String id) => _selectedPrograms.containsKey(id);

  bool isInResults(String id) => searchResults.any((p) => p.id == id);

  Future<bool> save() async {
    if (!canSave) {
      return false;
    }
    isSaving = true;
    notifyListeners();

    try {
      final preference = await _userPreferenceRepository.load();
      await _userPreferenceRepository.save(
        preference.copyWith(
          selectedProgramIds: _selectedPrograms.keys.toSet(),
        ),
      );
      _initialIds = _selectedPrograms.keys.toSet();
      return true;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}

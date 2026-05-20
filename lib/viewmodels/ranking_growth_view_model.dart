import 'package:flutter/foundation.dart';
import 'package:picktory/models/ranking_growth_record.dart';
import 'package:picktory/services/ranking_repository.dart';

class RankingGrowthViewModel extends ChangeNotifier {
  RankingGrowthViewModel({required RankingRepository rankingRepository})
      : _rankingRepository = rankingRepository;

  final RankingRepository _rankingRepository;

  bool _isLoading = false;
  String? _errorMessage;
  RankingGrowthRecord? _record;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RankingGrowthRecord? get record => _record;

  Future<void> load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _record = await _rankingRepository.fetchGrowthRecord();
    } catch (_) {
      _errorMessage = '성장 기록을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

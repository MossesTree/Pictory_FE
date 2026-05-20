import 'package:flutter/foundation.dart';
import 'package:picktory/models/my_page_summary.dart';
import 'package:picktory/services/my_repository.dart';

class MyViewModel extends ChangeNotifier {
  MyViewModel({required MyRepository myRepository})
      : _myRepository = myRepository;

  final MyRepository _myRepository;

  MyPageSummary? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  MyPageSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _myRepository.fetchSummary();
    } catch (_) {
      _errorMessage = '마이페이지 정보를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateNickname(String nickname) async {
    final trimmed = nickname.trim();
    if (trimmed.length < 2 || trimmed.length > 12) {
      return false;
    }
    try {
      await _myRepository.updateNickname(trimmed);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

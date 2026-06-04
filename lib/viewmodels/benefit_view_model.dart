import 'package:flutter/foundation.dart';
import 'package:picktory/models/attendance_check_in_result.dart';
import 'package:picktory/models/benefit_feed.dart';
import 'package:picktory/services/benefit_repository.dart';

class BenefitViewModel extends ChangeNotifier {
  BenefitViewModel({required BenefitRepository benefitRepository})
      : _benefitRepository = benefitRepository;

  final BenefitRepository _benefitRepository;

  BenefitFeed _feed = BenefitFeed.empty;
  bool _isLoading = false;
  bool _isCheckingIn = false;
  String? _errorMessage;

  BenefitFeed get feed => _feed;
  bool get isLoading => _isLoading;
  bool get isCheckingIn => _isCheckingIn;
  String? get errorMessage => _errorMessage;

  /// IA B-1: 연속 출석 일수 강조 (2일 이상부터 표시)
  String? get attendanceStreakLabel {
    if (_feed.consecutiveDays < 2) {
      return null;
    }
    return '${_feed.consecutiveDays}일 연속 🔥';
  }

  String get checkInButtonLabel =>
      _feed.checkedInToday ? '오늘 출석 완료' : '오늘 출석하기';

  bool get canCheckInToday => !_feed.checkedInToday && !_isCheckingIn;

  Future<void> load({bool isRefresh = false}) async {
    if (_isLoading) {
      return;
    }
    _isLoading = !isRefresh;
    _errorMessage = null;
    notifyListeners();

    try {
      _feed = await _benefitRepository.fetchFeed();
    } catch (_) {
      _errorMessage = '혜택 정보를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load(isRefresh: true);

  Future<AttendanceCheckInResult?> checkInToday() async {
    if (!canCheckInToday) {
      return null;
    }
    _isCheckingIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _benefitRepository.checkInToday();
      if (result != null) {
        await load(isRefresh: true);
      }
      return result;
    } catch (_) {
      _errorMessage = '출석체크에 실패했습니다.';
      notifyListeners();
      return null;
    } finally {
      _isCheckingIn = false;
      notifyListeners();
    }
  }

  Future<int?> onAdWatchCompleted() async {
    try {
      final earned = await _benefitRepository.completeAdWatch();
      if (earned != null) {
        await load(isRefresh: true);
      }
      return earned;
    } catch (_) {
      _errorMessage = '광고 보상 지급에 실패했습니다.';
      notifyListeners();
      return null;
    }
  }
}

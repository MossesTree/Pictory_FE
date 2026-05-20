import 'package:flutter/foundation.dart';
import 'package:picktory/models/report_reason.dart';
import 'package:picktory/services/community_repository.dart';

class CommunityReportViewModel extends ChangeNotifier {
  CommunityReportViewModel({
    required CommunityRepository communityRepository,
    required ReportTargetType targetType,
    required String targetId,
  })  : _communityRepository = communityRepository,
        _targetType = targetType,
        _targetId = targetId;

  final CommunityRepository _communityRepository;
  final ReportTargetType _targetType;
  final String _targetId;

  ReportReason? _selectedReason;
  String detail = '';
  bool isSubmitting = false;
  String? errorMessage;
  bool isSuccess = false;

  ReportReason? get selectedReason => _selectedReason;
  bool get canSubmit => _selectedReason != null && !isSubmitting;

  void selectReason(ReportReason reason) {
    _selectedReason = reason;
    notifyListeners();
  }

  void updateDetail(String value) {
    detail = value;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) {
      return false;
    }
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _communityRepository.submitReport(
        targetType: _targetType,
        targetId: _targetId,
        reason: _selectedReason!,
        detail: detail.trim().isEmpty ? null : detail.trim(),
      );
      isSuccess = true;
      return true;
    } catch (_) {
      errorMessage = '신고 접수에 실패했습니다.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}

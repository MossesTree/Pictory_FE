import 'package:flutter/foundation.dart';
import 'package:picktory/models/special_badge.dart';
import 'package:picktory/services/my_repository.dart';

class MySpecialBadgesViewModel extends ChangeNotifier {
  MySpecialBadgesViewModel({required MyRepository myRepository})
      : _myRepository = myRepository;

  final MyRepository _myRepository;

  List<SpecialBadge> _badges = const [];
  bool _isLoading = false;

  List<SpecialBadge> get badges => List<SpecialBadge>.unmodifiable(_badges);
  List<SpecialBadge> get earnedBadges =>
      _badges.where((b) => b.isEarned).toList();
  List<SpecialBadge> get lockedBadges =>
      _badges.where((b) => !b.isEarned).toList();
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _badges = await _myRepository.fetchSpecialBadges();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

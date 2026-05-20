import 'package:flutter/foundation.dart';
import 'package:picktory/models/pick_history_item.dart';
import 'package:picktory/services/my_repository.dart';

class MyPickHistoryViewModel extends ChangeNotifier {
  MyPickHistoryViewModel({required MyRepository myRepository})
      : _myRepository = myRepository;

  final MyRepository _myRepository;

  PickHistoryFilter _filter = PickHistoryFilter.all;
  List<PickHistoryItem> _items = const [];
  bool _isLoading = false;

  PickHistoryFilter get filter => _filter;
  List<PickHistoryItem> get items => List<PickHistoryItem>.unmodifiable(_items);
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _myRepository.fetchPickHistory(_filter);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectFilter(PickHistoryFilter filter) {
    if (_filter == filter) {
      return;
    }
    _filter = filter;
    load();
  }
}

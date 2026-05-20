import 'package:flutter/foundation.dart';
import 'package:picktory/models/story_item.dart';
import 'package:picktory/services/story_repository.dart';

class StoryDetailViewModel extends ChangeNotifier {
  StoryDetailViewModel({
    required String storyId,
    required StoryRepository storyRepository,
  })  : _storyId = storyId,
        _storyRepository = storyRepository;

  final String _storyId;
  final StoryRepository _storyRepository;

  bool _isLoading = false;
  String? _errorMessage;
  StoryItem? _story;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  StoryItem? get story => _story;

  Future<void> loadStory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _story = await _storyRepository.fetchStoryById(_storyId);
      if (_story == null) {
        _errorMessage = '이야기를 찾을 수 없습니다.';
      }
    } catch (_) {
      _errorMessage = '이야기를 불러오지 못했습니다.';
      _story = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

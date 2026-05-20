import 'package:picktory/models/story_item.dart';

abstract class StoryRepository {
  Future<List<StoryItem>> fetchStories({Set<String>? programIds});

  Future<StoryItem?> fetchStoryById(String id);
}

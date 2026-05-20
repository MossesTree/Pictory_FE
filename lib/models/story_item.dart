import 'package:picktory/models/genre.dart';

class StoryItem {
  const StoryItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.genre,
    required this.body,
  });

  final String id;
  final String title;
  final String summary;
  final Genre genre;
  final String body;

  StoryItem copyWith({
    String? id,
    String? title,
    String? summary,
    Genre? genre,
    String? body,
  }) {
    return StoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      genre: genre ?? this.genre,
      body: body ?? this.body,
    );
  }
}

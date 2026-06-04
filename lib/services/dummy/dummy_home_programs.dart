import 'package:picktory/models/home_program_item.dart';

abstract final class DummyHomePrograms {
  static const List<HomeProgramItem> items = [
    HomeProgramItem(id: 'all', label: '전체', isAll: true),
    HomeProgramItem(
      id: 'prog-solo',
      label: '나는 솔로',
      shortLabel: '나는\n솔로',
      emoji: '💛',
    ),
    HomeProgramItem(
      id: 'prog-transit',
      label: '환승연애',
      shortLabel: '환승\n연애',
      emoji: '💜',
    ),
    HomeProgramItem(
      id: 'prog-chef',
      label: '흑백요리사',
      shortLabel: '흑백\n요리사',
      emoji: '🍳',
    ),
    HomeProgramItem(
      id: 'prog-produce',
      label: '프로듀스',
      shortLabel: '프로듀스',
      emoji: '🎤',
    ),
  ];
}

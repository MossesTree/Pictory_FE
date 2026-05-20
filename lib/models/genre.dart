enum Genre {
  fantasy('판타지'),
  romance('로맨스'),
  mystery('미스터리'),
  sf('SF'),
  horror('호러'),
  daily('일상');

  const Genre(this.label);

  final String label;
}

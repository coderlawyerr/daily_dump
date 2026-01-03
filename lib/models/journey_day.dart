class JourneyDay {
  final int day; // Gün numarası (1–21)
  bool isCompleted; // Bu gün tamamlandı mı?

  JourneyDay({
    required this.day,
    this.isCompleted = false,
  });
}

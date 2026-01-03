import 'package:flutter/material.dart';
import '../models/journey_day.dart';

class JourneyProvider extends ChangeNotifier {
  // 21 günlük yol
  final List<JourneyDay> _days = List.generate(
    21,
    (index) => JourneyDay(day: index + 1),
  );

  String _goal = '';

  // Dışarıya SADECE okunabilir liste veriyoruz
  List<JourneyDay> get days => _days;

  String get goal => _goal;

  // Şu an kaç gün tamamlandı?
  int get completedDaysCount {
    return _days.where((day) => day.isCompleted).length;
  }

  // Belirli bir günü tamamla
  void completeDay(int dayNumber) {
    final day = _days.firstWhere((d) => d.day == dayNumber);

    if (!day.isCompleted) {
      day.isCompleted = true;
      notifyListeners(); // UI'ya haber ver
    }
  }

  // Tüm yolculuğu sıfırla
  void resetJourney() {
    for (var day in _days) {
      day.isCompleted = false;
    }
    notifyListeners();
  }

  // Hedefi ayarla
  void setGoal(String newGoal) {
    _goal = newGoal;
    notifyListeners();
  }

  // Hedefe ulaşıldı mı?
  bool get isGoalReached => completedDaysCount == 21;
}

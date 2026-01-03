import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../core/constants/app_color.dart';
import '../providers/journey_provider.dart';

class DayDetailScreen extends StatefulWidget {
  final int day;

  const DayDetailScreen({super.key, required this.day});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JourneyProvider>();

    final currentDay = provider.days.firstWhere(
      (d) => d.day == widget.day,
      orElse: () => provider.days.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Gün ${widget.day}'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.surface,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentDay.isCompleted ? Icons.check_circle : Icons.today,
                    size: 100,
                    color: currentDay.isCompleted ? AppColors.success : AppColors.primary,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    currentDay.isCompleted ? 'Harika! Gün ${widget.day} tamamlandı! 🎉' : 'Bugün alışkanlığını tamamladın mı?',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentDay.isCompleted ? 'Devam et, hedefe yaklaşıyorsun!' : 'Alışkanlığını tamamlamak için hazır mısın?',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: currentDay.isCompleted
                        ? null
                        : () {
                            // Provider state değiştir
                            provider.completeDay(widget.day);
                            // Confetti başlat
                            _confettiController.play();
                            // Kısa bir süre sonra ekranı kapat
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          },
                    child: Text(
                      currentDay.isCompleted ? 'Tamamlandı 🎉' : 'Tamamla',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
            ),
          ),
        ],
      ),
    );
  }
}

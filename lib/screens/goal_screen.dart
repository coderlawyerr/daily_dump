import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_color.dart';
import '../providers/journey_provider.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JourneyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tebrikler!'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.success.withOpacity(0.1),
              AppColors.accent.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration,
                  size: 120,
                  color: AppColors.success,
                ),
                const SizedBox(height: 32),
                Text(
                  'Hedefe Ulaştın! 🎉',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '21 günlük yolculuğunu başarıyla tamamladın. Kendinle gurur duy!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    provider.resetJourney();
                    Navigator.pop(context);
                  },
                  child: const Text('Yeni Yolculuğa Başla'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_color.dart';
import '../providers/journey_provider.dart';
import '../widgets/journey_path.dart';
import '../widgets/progress_header.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journeyProvider = context.watch<JourneyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gün ${journeyProvider.completedDaysCount + 1}${journeyProvider.goal.isNotEmpty ? ': ${journeyProvider.goal}' : ''}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.textSecondary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Yolculuğu Sıfırla'),
                  content: const Text('Tüm ilerlemeyi sıfırlamak istediğinizden emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        journeyProvider.resetJourney();
                        Navigator.pop(context);
                      },
                      child: const Text('Sıfırla'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ProgressHeader(),
          Expanded(
            child: const JourneyPath(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: journeyProvider.completedDaysCount < 21
            ? () {
                journeyProvider.completeDay(
                  journeyProvider.completedDaysCount + 1,
                );
              }
            : null,
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_color.dart';
import '../providers/journey_provider.dart';
import '../screens/day_detail_screen.dart';
import '../screens/goal_screen.dart';

class JourneyPath extends StatelessWidget {
  const JourneyPath({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JourneyProvider>();
    final days = provider.days;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.5),
          ],
        ),
      ),
      child: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: days.length + 1, // +1 for goal
          itemBuilder: (context, index) {
            if (index == days.length) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 3,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildGoalCard(context, provider.isGoalReached),
                  ),
                ),
              );
            }

            final day = days[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 3,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: _buildDayCard(context, day),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, dynamic day) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DayDetailScreen(day: day.day),
          ),
        );
      },
      child: Card(
        elevation: day.isCompleted ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: day.isCompleted ? AppColors.completedCard : AppColors.pendingCard,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: day.isCompleted
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.1),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: day.isCompleted ? AppColors.primary : AppColors.textSecondary.withOpacity(0.2),
                  boxShadow: day.isCompleted
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: day.isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        )
                      : Text(
                          '${day.day}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gün ${day.day}',
                style: TextStyle(
                  color: day.isCompleted ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, bool isReached) {
    return GestureDetector(
      onTap: isReached
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoalScreen()),
              );
            }
          : null,
      child: Card(
        elevation: isReached ? 12 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isReached ? AppColors.success.withOpacity(0.1) : AppColors.pendingCard,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isReached
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.success.withOpacity(0.2),
                      AppColors.accent.withOpacity(0.1),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReached ? AppColors.success : AppColors.textSecondary.withOpacity(0.2),
                  boxShadow: isReached
                      ? [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    isReached ? Icons.flag : Icons.flag_outlined,
                    color: isReached ? Colors.white : AppColors.textSecondary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hedef',
                style: TextStyle(
                  color: isReached ? AppColors.success : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

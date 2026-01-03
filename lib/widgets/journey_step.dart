import 'package:flutter/material.dart';

import '../core/constants/app_color.dart';
import '../screens/day_detail_screen.dart';

class JourneyStep extends StatefulWidget {
  final int day;
  final bool isCompleted;
  final bool isLeft;

  const JourneyStep({
    super.key,
    required this.day,
    required this.isCompleted,
    required this.isLeft,
  });

  @override
  State<JourneyStep> createState() => _JourneyStepState();
}

class _JourneyStepState extends State<JourneyStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(JourneyStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted && !oldWidget.isCompleted) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Branch from trunk
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        // Apple
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: _buildCircle(context),
        ),
      ],
    );
  }

  Widget _buildCircle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DayDetailScreen(day: widget.day),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isCompleted)
                  Container(
                    width: 4,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.isCompleted
                        ? LinearGradient(
                            colors: [AppColors.apple, AppColors.appleLight],
                          )
                        : LinearGradient(
                            colors: [Colors.grey.shade300, Colors.grey.shade400],
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isCompleted ? AppColors.apple.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: widget.isCompleted ? AppColors.apple : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: widget.isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        )
                      : Text(
                          '${widget.day}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

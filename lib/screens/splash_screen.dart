import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'journey_screen.dart';
import '../providers/journey_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _goalController = TextEditingController();
  bool _showInput = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();

    // Show input after animation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showInput = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _startJourney() {
    final goal = _goalController.text.trim();
    if (goal.isNotEmpty) {
      context.read<JourneyProvider>().setGoal(goal);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const JourneyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: _showInput ? _buildGoalInput() : _buildSplash(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplash() {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '21',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                ),
          ),
          Text(
            'DailyDump',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            '21 Günlük Yolculuğuna Başla',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalInput() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '21 günde ne yapmak istiyorsun?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _goalController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Örneğin: Spor yapmak, kitap okumak...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            textAlign: TextAlign.center,
            onSubmitted: (_) => _startJourney(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _startJourney,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
            child: const Text('Başla'),
          ),
        ],
      ),
    );
  }
}

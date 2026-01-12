import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../utils/app_decoration.dart';
import '../widgets/rpe_dialog.dart';
import '../models/running_session.dart';
import '../services/session_repository.dart';
import 'main_screen.dart';

class RunTrackingScreen extends StatefulWidget {
  const RunTrackingScreen({super.key});

  @override
  State<RunTrackingScreen> createState() => _RunTrackingScreenState();
}

class _RunTrackingScreenState extends State<RunTrackingScreen> {
  bool _isRunning = false;
  bool _isPaused = false;

  int _durationInSeconds = 0;
  double _distanceInKm = 0.0;

  Timer? _timer;
  final SessionRepository _repository = SessionRepository();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRun() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _durationInSeconds = 0;
      _distanceInKm = 0.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) {
        setState(() {
          _durationInSeconds++;
          _distanceInKm += 0.01;
        });
      }
    });
  }

  void _pauseRun() => setState(() => _isPaused = true);
  void _resumeRun() => setState(() => _isPaused = false);

  Future<void> _stopRun(int rpe) async {
    _timer?.cancel();

    final session = RunningSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      durationInSeconds: _durationInSeconds,
      distanceInKm: _distanceInKm,
      rpe: rpe,
    );

    await _repository.saveSession(session);

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _durationInSeconds = 0;
      _distanceInKm = 0.0;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Run saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        },
      ),
      title: const Text('Track Run', style: TextStyle(color: Colors.black)),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildProgressCircle(),
          const SizedBox(height: 48),
          if (_isRunning) _buildStats(),
          const SizedBox(height: 48),
          _isRunning ? _buildControls() : _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildProgressCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 240,
          height: 240,
          // ✅ CHANGED: Use AppDecorations.circleShadow
          decoration: AppDecorations.circleShadow,
        ),
        Container(
          width: 200,
          height: 200,
          // ✅ CHANGED: Use AppDecorations.circleGradient
          decoration: _isRunning
              ? (_isPaused
                  ? AppDecorations.circleGradient(
                      const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                      ),
                    )
                  : AppDecorations.circleGradient(AppColors.successGradient))
              : AppDecorations.circleGradient(AppColors.primaryGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRunning
                      ? (_isPaused ? Icons.pause : Icons.directions_run)
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  _isRunning
                      ? Formatters.duration(_durationInSeconds)
                      : 'Ready',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (!_isRunning)
                  Text(
                    'to Run',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _statCard(
          'Distance',
          Formatters.distance(_distanceInKm),
          Icons.straighten,
        ),
        const SizedBox(width: 16),
        _statCard(
          'Pace',
          Formatters.pace(_distanceInKm, _durationInSeconds),
          Icons.speed,
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        // ✅ CHANGED: Use AppDecorations.card
        decoration: AppDecorations.card,
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _startRun,
        // ✅ CHANGED: Use AppDecorations.elevatedButtonDark
        style: AppDecorations.elevatedButtonDark,
        child: const Text('START RUN'),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isPaused ? _resumeRun : _pauseRun,
            // ✅ CHANGED: Use AppDecorations.elevatedButtonLight
            style: AppDecorations.elevatedButtonLight,
            child: Text(_isPaused ? 'RESUME' : 'PAUSE'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _showStopDialog,
            // ✅ CHANGED: Use AppDecorations.elevatedButtonDark
            style: AppDecorations.elevatedButtonDark,
            child: const Text('STOP'),
          ),
        ),
      ],
    );
  }

  void _showStopDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RPEDialog(
        onSave: (rpe) {
          Navigator.pop(context);
          _stopRun(rpe);
        },
      ),
    );
  }
}
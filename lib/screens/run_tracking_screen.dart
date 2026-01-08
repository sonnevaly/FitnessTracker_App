import 'dart:async';
import 'package:fitness_tracker/screens/main_screen.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/rpe_dialog.dart';
import '../models/running_session.dart';
import '../services/database_service.dart';

class RunTrackingScreen extends StatefulWidget {
  const RunTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RunTrackingScreen> createState() => _RunTrackingScreenState();
}

class _RunTrackingScreenState extends State<RunTrackingScreen> {
  // ===== STATE =====
  bool _isRunning = false;
  bool _isPaused = false;
  int _duration = 0;      // seconds
  double _distance = 0.0; // km

  Timer? _timer;

  // ===== FORMATTERS =====
  String get formattedDuration {
    final h = _duration ~/ 3600;
    final m = (_duration % 3600) ~/ 60;
    final s = _duration % 60;
    return '${h.toString().padLeft(2, '0')}:'
           '${m.toString().padLeft(2, '0')}:'
           '${s.toString().padLeft(2, '0')}';
  }

  String get formattedDistance => _distance.toStringAsFixed(2);

  String get formattedPace {
    if (_distance == 0) return '0:00';
    final secPerKm = _duration / _distance;
    final min = secPerKm ~/ 60;
    final sec = (secPerKm % 60).round();
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  // ===== LIFECYCLE =====
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ===== RUN CONTROL =====
  void startRun() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _duration = 0;
      _distance = 0.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) {
        setState(() {
          _duration++;
          _distance += 0.01; // fake GPS (submission-safe)
        });
      }
    });
  }

  void pauseRun() => setState(() => _isPaused = true);
  void resumeRun() => setState(() => _isPaused = false);

  Future<void> stopRun(int rpe) async {
    _timer?.cancel();

    final session = RunningSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      durationInSeconds: _duration,
      distanceInKm: _distance,
      rpe: rpe,
    );

    await DatabaseService.instance.insertSession(session);

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _duration = 0;
      _distance = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Run saved')),
    );
  }

  // ===== UI =====
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
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
              ),
            );
          },
      ),
      title: const Text(
        'Track Run',
        style: TextStyle(color: Colors.black),
      ),
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

  // ===== COMPONENTS =====
  Widget _buildProgressCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isRunning
                ? (_isPaused
                    ? const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                      )
                    : AppColors.successGradient)
                : AppColors.primaryGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRunning
                      ? (_isPaused
                          ? Icons.pause
                          : Icons.directions_run)
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  _isRunning ? formattedDuration : 'Ready',
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
        _statCard('Distance', '$formattedDistance km', Icons.straighten),
        const SizedBox(width: 16),
        _statCard('Pace', formattedPace, Icons.speed),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
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
        onPressed: startRun,
        style: _darkButtonStyle(),
        child: const Text('START RUN'),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isPaused ? resumeRun : pauseRun,
            style: _lightButtonStyle(),
            child: Text(_isPaused ? 'RESUME' : 'PAUSE'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _showStopDialog,
            style: _darkButtonStyle(),
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
          stopRun(rpe);
        },
      ),
    );
  }

  // ===== STYLES =====
  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  ButtonStyle _darkButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: AppColors.cardDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      );

  ButtonStyle _lightButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      );
}

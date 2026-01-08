import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/rpe_dialog.dart';

class RunTrackingScreen extends StatefulWidget {
  const RunTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RunTrackingScreen> createState() => _RunTrackingScreenState();
}

class _RunTrackingScreenState extends State<RunTrackingScreen> {
  // Local state variables (NO PROVIDER!)
  bool _isRunning = false;
  bool _isPaused = false;
  int _duration = 0; // in seconds
  double _distance = 0.0; // in kilometers
  
  Timer? _timer;
  
  // Computed values
  String get _formattedDuration {
    int hours = _duration ~/ 3600;
    int minutes = (_duration % 3600) ~/ 60;
    int seconds = _duration % 60;
    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }
  
  String get _formattedDistance {
    return _distance.toStringAsFixed(2);
  }
  
  String get _formattedPace {
    if (_distance == 0) return '0:00';
    double paceInSeconds = (_duration / _distance) / 60;
    int minutes = paceInSeconds.floor();
    int seconds = ((paceInSeconds - minutes) * 60).floor();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRun() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _duration = 0;
      _distance = 0.0;
    });
    
    // Start timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _duration++;
          // Fake distance increment (0.01 km per second)
          _distance += 0.01;
        });
      }
    });
  }
  
  void _pauseRun() {
    setState(() {
      _isPaused = true;
    });
  }
  
  void _resumeRun() {
    setState(() {
      _isPaused = false;
    });
  }
  
  Future<void> _stopRun(int rpe) async {
    _timer?.cancel();
    
    // Save data here (for now just print)
    print('Run saved: ${_distance}km in ${_formattedDuration}, RPE: $rpe');
    
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _duration = 0;
      _distance = 0.0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Run saved with RPE $rpe!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Track Run',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 40),
                
                _buildProgressCircle(),
                
                SizedBox(height: 48),
                
                if (_isRunning) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniStatCard(
                          'Distance',
                          '$_formattedDistance km',
                          Icons.straighten,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildMiniStatCard(
                          'Pace',
                          _formattedPace,
                          Icons.speed,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                ],
                
                if (!_isRunning)
                  _buildStartButton()
                else
                  _buildControlButtons(),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: Offset(0, 10),
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
                    ? LinearGradient(
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
                SizedBox(height: 12),
                Text(
                  _isRunning ? _formattedDuration : 'Ready',
                  style: TextStyle(
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
  
  Widget _buildMiniStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _startRun,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          'START RUN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
  
  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton(
              onPressed: _isPaused ? _resumeRun : _pauseRun,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Text(
                _isPaused ? 'RESUME' : 'PAUSE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton(
              onPressed: () => _showStopDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'STOP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showStopDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RPEDialog(
        onSave: (rpe) {
          Navigator.pop(context);
          _stopRun(rpe);
        },
      ),
    );
  }
}
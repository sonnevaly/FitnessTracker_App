import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/weekly_stats.dart';
import '../services/session_repository.dart';
import '../utils/formatters.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  WeeklyStats? lifetimeStats;
  bool isLoading = false;

  final SessionRepository _repository = SessionRepository();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => isLoading = true);

    final sessions = await _repository.getAllSessions();
    
    final stats = WeeklyStats.fromSessions(sessions);

    setState(() {
      lifetimeStats = stats;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (lifetimeStats != null) _buildStats(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          lifetimeStats!.numberOfRuns.toString(),
          'Runs',
        ),
        _StatItem(
          lifetimeStats!.totalDistance.toStringAsFixed(1),
          'KM',
        ),
        _StatItem(
          lifetimeStats!.formattedTotalDuration,
          'Duration',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/running_session.dart';

class SessionsList extends StatelessWidget {
  final List<RunningSession> sessions;
  final Function(String) onDelete;
  final Function(RunningSession) onTap;

  const SessionsList({
    Key? key,
    required this.sessions,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'No runs recorded yet.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getRPEColor(session.rpe),
              child: Text(
                session.rpe.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              '${session.distanceInKm.toStringAsFixed(2)} km',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${_formatDuration(session.durationInSeconds)} • ${_formatDate(session.date)}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(session.id),
            ),
            onTap: () => onTap(session),
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getRPEColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
}

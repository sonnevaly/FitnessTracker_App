import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../utils/formatters.dart';
import '../utils/rpe_utils.dart';

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
              // ✅ CHANGED: RPEHelper → RpeUtils
              backgroundColor: RpeUtils.getColor(session.rpe),
              child: Text(
                session.rpe.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              Formatters.distance(session.distanceInKm),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${Formatters.duration(session.durationInSeconds)} • ${Formatters.date(session.date)}',
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
}
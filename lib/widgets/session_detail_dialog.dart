import 'package:flutter/material.dart';
import '../models/running_session.dart';

class SessionDetailDialog extends StatelessWidget {
  final RunningSession session;

  const SessionDetailDialog({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Run Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Date', _formatDate(session.date)),
          _buildRow('Distance', '${session.distanceInKm.toStringAsFixed(2)} km'),
          _buildRow('Duration', _formatDuration(session.durationInSeconds)),
          _buildRow('RPE', session.rpe.toString()),
          _buildRow('Training Load', session.trainingLoad.toStringAsFixed(0)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:'),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
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
}

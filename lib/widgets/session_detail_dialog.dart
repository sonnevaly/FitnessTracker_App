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
          _buildRow('Distance', session.formattedDistance),
          _buildRow('Duration', session.formattedDuration),
          _buildRow('Pace', '${session.formattedPace} /km'),
          _buildRow('RPE', session.rpe.toString()),
          _buildRow(
            'Training Load',
            session.trainingLoad.toStringAsFixed(0),
          ),
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
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

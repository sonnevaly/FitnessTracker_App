import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../utils/formatters.dart';

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
          _row('Date', Formatters.date(session.date)),
          _row('Distance', Formatters.distance(session.distanceInKm)),
          _row('Duration', Formatters.duration(session.durationInSeconds)),
          _row('Pace', Formatters.pace(session.distanceInKm, session.durationInSeconds)),
          _row('RPE', session.rpe.toString()),
          _row('Training Load', session.trainingLoad.toStringAsFixed(0)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

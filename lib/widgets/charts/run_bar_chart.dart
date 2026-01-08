import 'package:flutter/material.dart';

class RunsBarChart extends StatelessWidget {
  final int runs;

  const RunsBarChart({
    super.key,
    required this.runs,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$runs runs',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

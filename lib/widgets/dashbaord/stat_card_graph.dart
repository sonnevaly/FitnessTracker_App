import 'package:flutter/material.dart';
import '../../utils/app_decoration.dart';

class StatCardWithGraph extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget chart;

  const StatCardWithGraph({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // ✅ CHANGED: Replaced BoxDecoration with AppDecorations.card
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          chart,
        ],
      ),
    );
  }
}
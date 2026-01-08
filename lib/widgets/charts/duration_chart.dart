import 'package:flutter/material.dart';

class DurationBarChart extends StatelessWidget {
  final List<int> durationsInMinutes;

  const DurationBarChart({
    super.key,
    required this.durationsInMinutes,
  });

  @override
  Widget build(BuildContext context) {
    if (durationsInMinutes.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: durationsInMinutes.length,
        itemBuilder: (_, i) {
          final value = durationsInMinutes[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${value}m'),
                const SizedBox(height: 6),
                Container(
                  width: 14,
                  height: value.toDouble() * 2,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

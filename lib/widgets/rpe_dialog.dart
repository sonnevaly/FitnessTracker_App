import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/rpe_utils.dart';

class RPEDialog extends StatefulWidget {
  final Function(int) onSave;

  const RPEDialog({super.key, required this.onSave});

  @override
  State<RPEDialog> createState() => _RPEDialogState();
}

class _RPEDialogState extends State<RPEDialog> {
  int _selectedRPE = 5;

  @override
  Widget build(BuildContext context) {
    final color = RpeUtils.getColor(_selectedRPE);
    final label = RpeUtils.getLabel(_selectedRPE);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How hard was\nyour run?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rate of Perceived Exertion',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),

            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_selectedRPE',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),

            const SizedBox(height: 40),

            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: color,
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: color,
                overlayColor: color.withOpacity(0.1),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                trackHeight: 6,
              ),
              child: Slider(
                value: _selectedRPE.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (value) {
                  setState(() {
                    _selectedRPE = value.toInt();
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1 Easy', style: TextStyle(color: AppColors.textSecondary)),
                  Text('10 Max', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget.onSave(_selectedRPE),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardDark,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Run'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
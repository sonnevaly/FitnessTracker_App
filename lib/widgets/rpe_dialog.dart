import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class RPEDialog extends StatefulWidget {
  final Function(int) onSave;
  
  const RPEDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  State<RPEDialog> createState() => _RPEDialogState();
}

class _RPEDialogState extends State<RPEDialog> {
  int _selectedRPE = 5;
  
  Color _getRPEColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
  
  String _getRPELabel(int rpe) {
    if (rpe <= 2) return 'Very Easy';
    if (rpe <= 4) return 'Easy';
    if (rpe <= 6) return 'Moderate';
    if (rpe <= 8) return 'Hard';
    return 'Very Hard';
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'How hard was your run?',
        style: AppTextStyles.h1,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Rate of Perceived Exertion (RPE)',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 24),
          
          // Large RPE number display
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _getRPEColor(_selectedRPE).withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: _getRPEColor(_selectedRPE),
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                '$_selectedRPE',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: _getRPEColor(_selectedRPE),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            _getRPELabel(_selectedRPE),
            style: AppTextStyles.h3.copyWith(
              color: _getRPEColor(_selectedRPE),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Slider (1-10)
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getRPEColor(_selectedRPE),
              inactiveTrackColor: _getRPEColor(_selectedRPE).withOpacity(0.3),
              thumbColor: _getRPEColor(_selectedRPE),
              overlayColor: _getRPEColor(_selectedRPE).withOpacity(0.2),
            ),
            child: Slider(
              value: _selectedRPE.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_selectedRPE',
              onChanged: (value) {
                setState(() {
                  _selectedRPE = value.toInt();
                });
              },
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1\nEasy', style: AppTextStyles.caption, textAlign: TextAlign.center),
              Text('10\nMax', style: AppTextStyles.caption, textAlign: TextAlign.center),
            ],
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        // Save button
        ElevatedButton(
          onPressed: () {
            widget.onSave(_selectedRPE);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _getRPEColor(_selectedRPE),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Save Run'),
        ),
      ],
    );
  }
}
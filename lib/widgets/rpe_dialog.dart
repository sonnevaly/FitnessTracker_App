import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

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
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'How hard was\nyour run?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                height: 1.3,
              ),
            ),
            
            SizedBox(height: 8),
            
            Text(
              'Rate of Perceived Exertion',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            SizedBox(height: 40),
            
            // Large RPE number with gradient background
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getRPEColor(_selectedRPE).withOpacity(0.2),
                    _getRPEColor(_selectedRPE).withOpacity(0.05),
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
                    color: _getRPEColor(_selectedRPE),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Label
            Text(
              _getRPELabel(_selectedRPE),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _getRPEColor(_selectedRPE),
              ),
            ),
            
            SizedBox(height: 40),
            
            // Slider
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _getRPEColor(_selectedRPE),
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: _getRPEColor(_selectedRPE),
                overlayColor: _getRPEColor(_selectedRPE).withOpacity(0.1),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
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
            
            // Min/Max labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 Easy',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '10 Max',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSave(_selectedRPE);  // ✅ Call callback
                        // ❌ REMOVED: Navigator.pop(context) - Let screen handle it!
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Run',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
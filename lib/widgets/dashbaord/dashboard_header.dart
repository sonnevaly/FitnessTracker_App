import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.grid_view_rounded),
                onPressed: () {},
              ),
              Row(
                children: [
                  Text(
                    'Hello, Runner',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.notifications_outlined),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 32),
          
          Text(
            'Discover how\nto track your runs',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/run_tracking_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.success,
          error: AppColors.error,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RunTrackingScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  void onItemTapped(int index) {  
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildModernBottomBar(),
    );
  }
  
  Widget _buildModernBottomBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 0),
          _buildNavItem(Icons.favorite_outline, Icons.favorite, 1),
          _buildNavItem(Icons.list_alt_outlined, Icons.list_alt, 2),
          _buildNavItem(Icons.person_outline, Icons.person, 3),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onItemTapped(index),  // ✅ NO UNDERSCORE
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          size: 28,
        ),
      ),
    );
  }
}
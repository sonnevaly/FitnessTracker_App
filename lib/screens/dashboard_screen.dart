import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/dashbaord/dashboard_header.dart';
import '../widgets/dashbaord/image_card.dart';
import '../widgets/dashbaord/stats_sections.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPeriod = 'This Week';
  bool _isLoading = false;
  
  // Mock data (replace with real data later)
  int _totalRuns = 5;
  double _totalDistance = 15.5;
  String _totalDuration = '2:30:00';
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: DashboardHeader(),
                  ),
                  
                  SliverToBoxAdapter(child: SizedBox(height: 24)),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: HeroImageCard(),
                    ),
                  ),
                  
                  SliverToBoxAdapter(child: SizedBox(height: 32)),
                  StatsSection(
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: _onPeriodChanged,
                    totalRuns: _totalRuns,
                    totalDistance: _totalDistance,
                    totalDuration: _totalDuration,
                  ),
                  
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }
}
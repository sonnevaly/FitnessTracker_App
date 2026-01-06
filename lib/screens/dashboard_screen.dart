import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
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
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<DashboardProvider>().loadDashboardData()
    );
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: provider.isLoading
            ? _buildLoadingState()
            : _buildContent(provider),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
  
  Widget _buildContent(DashboardProvider provider) {
    return CustomScrollView(
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
          stats: provider.weeklyStats,
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../widgets/session_detail_dialog.dart';
import '../utils/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false;
  List<RunningSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading - Replace with real database call later
    await Future.delayed(Duration(seconds: 1));

    // Mock data for now
    setState(() {
      _sessions = [
        RunningSession(
          id: '1',
          date: DateTime.now().subtract(Duration(days: 1)),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 6,
        ),
        RunningSession(
          id: '2',
          date: DateTime.now().subtract(Duration(days: 3)),
          durationInSeconds: 2400,
          distanceInKm: 7.5,
          rpe: 8,
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _deleteSession(String id) async {
    setState(() {
      _sessions.removeWhere((session) => session.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Run deleted'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Run History',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _sessions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No runs recorded yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _sessions.length,
                          itemBuilder: (context, index) {
                            final session = _sessions[index];
                            return _buildRunCard(session);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunCard(RunningSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getRPEColor(session.rpe).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              session.rpe.toString(),
              style: TextStyle(
                color: _getRPEColor(session.rpe),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          '${session.distanceInKm.toStringAsFixed(2)} km',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${session.formattedDuration} • ${_formatDate(session.date)}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () async {
            await _deleteSession(session.id);
          },
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => SessionDetailDialog(session: session),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getRPEColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
}
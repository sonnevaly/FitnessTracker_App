import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import '../models/running_session.dart';
import '../widgets/session_detail_dialog.dart';
import '../utils/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run History'),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.sessions.isEmpty
              ? const Center(
                  child: Text(
                    'No runs recorded yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.sessions.length,
                  itemBuilder: (context, index) {
                    final session = provider.sessions[index];
                    return _buildRunCard(session, provider);
                  },
                ),
    );
  }

  Widget _buildRunCard(RunningSession session, HistoryProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRPEColor(session.rpe),
          child: Text(
            session.rpe.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          '${session.distanceInKm.toStringAsFixed(2)} km',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${_formatDuration(session.durationInSeconds)} • ${_formatDate(session.date)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await provider.deleteSession(session.id);
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

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
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

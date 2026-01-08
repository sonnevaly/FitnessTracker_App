import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../services/session_repository.dart';
import '../widgets/sessions_list.dart';
import '../widgets/session_detail_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<RunningSession> sessions = [];
  bool isLoading = false;

  final SessionRepository repository = SessionRepository();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);

    final data = await repository.getAllSessions();

    setState(() {
      sessions = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SessionsList(
              sessions: sessions,
              onTap: (session) {
                showDialog(
                  context: context,
                  builder: (_) =>
                      SessionDetailDialog(session: session),
                );
              },
              onDelete: (id) async {
                await repository.deleteSession(id);
                _loadHistory();
              },
            ),
    );
  }
}

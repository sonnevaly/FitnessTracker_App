import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../services/session_repository.dart';

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
    sessions = await repository.getAllSessions();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (_, index) {
                final s = sessions[index];
                return ListTile(
                  title: Text('${s.distanceInKm} km'),
                  subtitle: Text('${s.durationInSeconds} sec'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await repository.deleteSession(s.id);
                      _loadHistory();
                    },
                  ),
                );
              },
            ),
    );
  }
}

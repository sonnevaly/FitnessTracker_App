import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../services/session_repository.dart';
import '../utils/formatters.dart';
import '../widgets/session_detail_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final SessionRepository repository = SessionRepository();

  List<RunningSession> sessions = [];
  bool isLoading = false;

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
          : sessions.isEmpty
              ? const Center(
                  child: Text(
                    'No runs yet',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: sessions.length,
                  itemBuilder: (_, index) {
                    final s = sessions[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        title: Text(
                          Formatters.distance(s.distanceInKm),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${Formatters.duration(s.durationInSeconds)} • ${Formatters.pace(s.distanceInKm, s.durationInSeconds)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await repository.deleteSession(s.id);
                            _loadHistory();
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                SessionDetailDialog(session: s),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
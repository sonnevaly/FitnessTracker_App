import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../services/session_repository.dart';
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
    sessions = await repository.getAllSessions();
    setState(() => isLoading = false);
  }

  String formatDistance(double km) => '${km.toStringAsFixed(2)} km';

  String formatDuration(int seconds) {
    final totalMinutes = seconds ~/ 60;
    if (totalMinutes < 60) return '$totalMinutes min';

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String formatPace(double km, int seconds) {
    if (km == 0) return '0:00 /km';

    final paceSeconds = seconds / km;
    final minutes = paceSeconds ~/ 60;
    final sec = (paceSeconds % 60).toInt();

    return '${minutes}:${sec.toString().padLeft(2, '0')} /km';
  }

  Color rpeColor(int rpe) {
    if (rpe <= 3) return Colors.green;
    if (rpe <= 6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
              ? const Center(child: Text('No runs yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: sessions.length,
                  itemBuilder: (_, index) {
                    final s = sessions[index];

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              SessionDetailDialog(session: s),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Distance + RPE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.straighten, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        formatDistance(s.distanceInKm),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          rpeColor(s.rpe).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'RPE ${s.rpe}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: rpeColor(s.rpe),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Duration & Pace
                              Row(
                                children: [
                                  const Icon(Icons.timer, size: 18),
                                  const SizedBox(width: 6),
                                  Text(formatDuration(s.durationInSeconds)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.speed, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    formatPace(
                                      s.distanceInKm,
                                      s.durationInSeconds,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Delete
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon:
                                      const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    await repository.deleteSession(s.id);
                                    _loadHistory();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

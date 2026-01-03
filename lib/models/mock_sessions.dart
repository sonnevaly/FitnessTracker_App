class MockSession {
  final String id;
  final DateTime date;
  final double distance;
  final int duration; // in seconds
  final int rpe;
  
  MockSession({
    required this.id,
    required this.date,
    required this.distance,
    required this.duration,
    required this.rpe,
  });
  
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  String get formattedDuration {
    int hours = duration ~/ 3600;
    int minutes = (duration % 3600) ~/ 60;
    int seconds = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }
  
  String get formattedPace {
    if (distance == 0) return '--:--';
    double paceInSeconds = (duration / distance) / 60;
    int minutes = paceInSeconds.floor();
    int seconds = ((paceInSeconds - minutes) * 60).floor();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}/km';
  }
}
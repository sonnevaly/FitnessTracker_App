class RunningSession {
  final int? id;
  final DateTime date;
  final int duration; // seconds
  final double distance; // km
  final int rpe;

  RunningSession({
    this.id,
    required this.date,
    required this.duration,
    required this.distance,
    required this.rpe,
  });

  double get pace => distance == 0 ? 0 : duration / distance;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'duration': duration,
      'distance': distance,
      'rpe': rpe,
    };
  }

  factory RunningSession.fromMap(Map<String, dynamic> map) {
    return RunningSession(
      id: map['id'],
      date: DateTime.parse(map['date']),
      duration: map['duration'],
      distance: map['distance'],
      rpe: map['rpe'],
    );
  }
}



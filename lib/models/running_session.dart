class RunningSession {
  final String id;
  final DateTime date;
  final int durationInSeconds;
  final double distanceInKm;
  final int rpe;

  RunningSession({
    required this.id,
    required this.date,
    required this.durationInSeconds,
    required this.distanceInKm,
    required this.rpe,
  });
  /// Returns pace in minutes per kilometer
  double get paceMinPerKm {
    if (distanceInKm == 0) return 0.0;
    return (durationInSeconds / 60) / distanceInKm;
  }

  /// Returns training load (duration × RPE)
  double get trainingLoad {
    return (durationInSeconds / 60) * rpe;
  }
  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'durationInSeconds': durationInSeconds,
      'distanceInKm': distanceInKm,
      'rpe': rpe,
    };
  }

  /// Create from Map (from database)
  factory RunningSession.fromMap(Map<String, dynamic> map) {
    return RunningSession(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      durationInSeconds: map['durationInSeconds'] as int,
      distanceInKm: (map['distanceInKm'] as num).toDouble(),
      rpe: map['rpe'] as int,
    );
  }

  /// Create a copy with modified fields
  RunningSession copyWith({
    String? id,
    DateTime? date,
    int? durationInSeconds,
    double? distanceInKm,
    int? rpe,
  }) {
    return RunningSession(
      id: id ?? this.id,
      date: date ?? this.date,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      rpe: rpe ?? this.rpe,
    );
  }

  @override
  String toString() {
    return 'RunningSession(id: $id, date: $date, distance: ${distanceInKm.toStringAsFixed(2)}km, duration: ${durationInSeconds}s, pace: ${paceMinPerKm.toStringAsFixed(2)}min/km, rpe: $rpe, load: ${trainingLoad.toStringAsFixed(0)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RunningSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
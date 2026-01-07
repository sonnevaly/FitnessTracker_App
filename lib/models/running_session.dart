  // lib/models/running_session.dart

  class RunningSession {
    final String id;
    final DateTime date;
    final int durationInSeconds;
    final double distanceInKm;
    final int rpe; // Rate of Perceived Exertion (1-10)

    RunningSession({
      required this.id,
      required this.date,
      required this.durationInSeconds,
      required this.distanceInKm,
      required this.rpe,
    });

    // Calculated properties
    
    /// Returns pace in minutes per kilometer
    double get paceMinPerKm {
      if (distanceInKm == 0) return 0.0;
      return (durationInSeconds / 60) / distanceInKm;
    }

    /// Returns training load (duration × RPE)
    double get trainingLoad {
      return (durationInSeconds / 60) * rpe;
    }

    /// Returns pace formatted as "5:24" (min:sec per km)
    String get formattedPace {
      if (distanceInKm == 0) return "0:00";
      
      int totalSeconds = (paceMinPerKm * 60).round();
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }

    /// Returns duration formatted as "27:30" or "1:05:30"
    String get formattedDuration {
      int hours = durationInSeconds ~/ 3600;
      int minutes = (durationInSeconds % 3600) ~/ 60;
      int seconds = durationInSeconds % 60;

      if (hours > 0) {
        return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    /// Returns distance formatted as "5.00 km"
    String get formattedDistance {
      return '${distanceInKm.toStringAsFixed(2)} km';
    }

    // Database conversion methods

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
        distanceInKm: map['distanceInKm'] as double,
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
      return 'RunningSession(id: $id, date: $date, distance: $formattedDistance, duration: $formattedDuration, pace: $formattedPace/km, rpe: $rpe, load: ${trainingLoad.toStringAsFixed(0)})';
    }
  }
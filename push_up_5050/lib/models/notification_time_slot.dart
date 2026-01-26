/// NotificationTimeSlot model
///
/// Tracks when a user completes a workout for personalized notification time calculation.
/// Each slot represents a single workout completion time.
class NotificationTimeSlot {
  /// When the workout was completed
  final DateTime timestamp;

  /// Hour of day (0-23) for quick binning without DateTime operations
  final int hour;

  /// Minute of hour (0-59)
  final int minute;

  /// Create a new notification time slot.
  ///
  /// All parameters are required.
  const NotificationTimeSlot({
    required this.timestamp,
    required this.hour,
    required this.minute,
  });

  /// Create a notification time slot from a timestamp.
  ///
  /// Extracts hour and minute automatically from the timestamp.
  factory NotificationTimeSlot.fromTimestamp(DateTime timestamp) {
    return NotificationTimeSlot(
      timestamp: timestamp,
      hour: timestamp.hour,
      minute: timestamp.minute,
    );
  }

  /// Serialize to JSON.
  ///
  /// Timestamp format: YYYY-MM-DD HH:mm
  /// Hour and minute stored separately for quick access.
  Map<String, dynamic> toJson() {
    return {
      'timestamp': _formatTimestamp(timestamp),
      'hour': hour,
      'minute': minute,
    };
  }

  /// Deserialize from JSON.
  ///
  /// Expected timestamp format: YYYY-MM-DD HH:mm
  factory NotificationTimeSlot.fromJson(Map<String, dynamic> json) {
    final timestampString = json['timestamp'] as String;
    final parts = timestampString.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    return NotificationTimeSlot(
      timestamp: DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      ),
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }

  /// Calculate the 2-hour window bin for this time slot.
  ///
  /// Returns the starting hour of the 2-hour window:
  /// - Hours 0-1 return 0
  /// - Hours 2-3 return 2
  /// - Hours 4-5 return 4
  /// - ...
  /// - Hours 22-23 return 22
  ///
  /// Used for grouping workout times into 2-hour windows for analysis.
  int toHourBin() {
    return (hour ~/ 2) * 2;
  }

  /// Format timestamp as YYYY-MM-DD HH:mm for JSON serialization.
  String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'NotificationTimeSlot(timestamp: $timestamp, hour: $hour, minute: $minute, bin: ${toHourBin()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationTimeSlot &&
        other.timestamp == timestamp &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode => timestamp.hashCode ^ hour.hashCode ^ minute.hashCode;
}

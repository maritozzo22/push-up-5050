import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/notification_time_slot.dart';

void main() {
  group('NotificationTimeSlot', () {
    test('should create notification time slot with required params', () {
      final timestamp = DateTime(2025, 1, 26, 14, 30);
      final slot = NotificationTimeSlot(
        timestamp: timestamp,
        hour: 14,
        minute: 30,
      );

      expect(slot.timestamp, timestamp);
      expect(slot.hour, 14);
      expect(slot.minute, 30);
    });

    test('should extract hour from timestamp when hour/minute not provided', () {
      final timestamp = DateTime(2025, 1, 26, 14, 30);
      final slot = NotificationTimeSlot.fromTimestamp(timestamp);

      expect(slot.timestamp, timestamp);
      expect(slot.hour, 14);
      expect(slot.minute, 30);
    });

    test('should serialize to JSON with YYYY-MM-DD HH:mm format', () {
      final timestamp = DateTime(2025, 1, 26, 14, 30);
      final slot = NotificationTimeSlot(
        timestamp: timestamp,
        hour: 14,
        minute: 30,
      );

      final json = slot.toJson();

      expect(json['timestamp'], '2025-01-26 14:30');
      expect(json['hour'], 14);
      expect(json['minute'], 30);
    });

    test('should deserialize from JSON with YYYY-MM-DD HH:mm format', () {
      final json = {
        'timestamp': '2025-01-26 14:30',
        'hour': 14,
        'minute': 30,
      };

      final slot = NotificationTimeSlot.fromJson(json);

      expect(slot.hour, 14);
      expect(slot.minute, 30);
      expect(slot.timestamp, DateTime(2025, 1, 26, 14, 30));
    });

    test('should calculate hour bin correctly (2-hour windows)', () {
      // Hour 0-1 -> bin 0
      expect(NotificationTimeSlot(hour: 0, minute: 0, timestamp: DateTime.now()).toHourBin(), 0);
      expect(NotificationTimeSlot(hour: 1, minute: 59, timestamp: DateTime.now()).toHourBin(), 0);

      // Hour 2-3 -> bin 2
      expect(NotificationTimeSlot(hour: 2, minute: 0, timestamp: DateTime.now()).toHourBin(), 2);
      expect(NotificationTimeSlot(hour: 3, minute: 59, timestamp: DateTime.now()).toHourBin(), 2);

      // Hour 4-5 -> bin 4
      expect(NotificationTimeSlot(hour: 4, minute: 0, timestamp: DateTime.now()).toHourBin(), 4);
      expect(NotificationTimeSlot(hour: 5, minute: 59, timestamp: DateTime.now()).toHourBin(), 4);

      // Hour 6-7 -> bin 6
      expect(NotificationTimeSlot(hour: 6, minute: 0, timestamp: DateTime.now()).toHourBin(), 6);
      expect(NotificationTimeSlot(hour: 7, minute: 59, timestamp: DateTime.now()).toHourBin(), 6);

      // Hour 8-9 -> bin 8
      expect(NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime.now()).toHourBin(), 8);
      expect(NotificationTimeSlot(hour: 9, minute: 59, timestamp: DateTime.now()).toHourBin(), 8);

      // Hour 10-11 -> bin 10
      expect(NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime.now()).toHourBin(), 10);
      expect(NotificationTimeSlot(hour: 11, minute: 59, timestamp: DateTime.now()).toHourBin(), 10);

      // Hour 12-13 -> bin 12
      expect(NotificationTimeSlot(hour: 12, minute: 0, timestamp: DateTime.now()).toHourBin(), 12);
      expect(NotificationTimeSlot(hour: 13, minute: 59, timestamp: DateTime.now()).toHourBin(), 12);

      // Hour 14-15 -> bin 14
      expect(NotificationTimeSlot(hour: 14, minute: 0, timestamp: DateTime.now()).toHourBin(), 14);
      expect(NotificationTimeSlot(hour: 15, minute: 59, timestamp: DateTime.now()).toHourBin(), 14);

      // Hour 16-17 -> bin 16
      expect(NotificationTimeSlot(hour: 16, minute: 0, timestamp: DateTime.now()).toHourBin(), 16);
      expect(NotificationTimeSlot(hour: 17, minute: 59, timestamp: DateTime.now()).toHourBin(), 16);

      // Hour 18-19 -> bin 18
      expect(NotificationTimeSlot(hour: 18, minute: 0, timestamp: DateTime.now()).toHourBin(), 18);
      expect(NotificationTimeSlot(hour: 19, minute: 59, timestamp: DateTime.now()).toHourBin(), 18);

      // Hour 20-21 -> bin 20
      expect(NotificationTimeSlot(hour: 20, minute: 0, timestamp: DateTime.now()).toHourBin(), 20);
      expect(NotificationTimeSlot(hour: 21, minute: 59, timestamp: DateTime.now()).toHourBin(), 20);

      // Hour 22-23 -> bin 22
      expect(NotificationTimeSlot(hour: 22, minute: 0, timestamp: DateTime.now()).toHourBin(), 22);
      expect(NotificationTimeSlot(hour: 23, minute: 59, timestamp: DateTime.now()).toHourBin(), 22);
    });

    test('should handle edge case: midnight (0:00)', () {
      final timestamp = DateTime(2025, 1, 26, 0, 0);
      final slot = NotificationTimeSlot.fromTimestamp(timestamp);

      expect(slot.hour, 0);
      expect(slot.minute, 0);
      expect(slot.toHourBin(), 0);
    });

    test('should handle edge case: last minute of day (23:59)', () {
      final timestamp = DateTime(2025, 1, 26, 23, 59);
      final slot = NotificationTimeSlot.fromTimestamp(timestamp);

      expect(slot.hour, 23);
      expect(slot.minute, 59);
      expect(slot.toHourBin(), 22);
    });

    test('should handle serialization roundtrip', () {
      final original = NotificationTimeSlot(
        timestamp: DateTime(2025, 1, 26, 14, 30),
        hour: 14,
        minute: 30,
      );

      final json = original.toJson();
      final restored = NotificationTimeSlot.fromJson(json);

      expect(restored.hour, original.hour);
      expect(restored.minute, original.minute);
      expect(restored.timestamp, original.timestamp);
    });
  });
}

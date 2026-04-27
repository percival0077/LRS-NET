import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lrs_net_chat/providers/ws_provider.dart';

void main() {
  group('GpsData', () {
    test('parses JSON correctly', () {
      final json = {
        'type': 'gps',
        'lat': '51.5074',
        'lon': '-0.1278',
        'fix': '3',
        'alt': '15.2',
        'course': '270',
        'date': '27/04/2025',
        'time': '12:00:00',
        'rssi': '-85',
        'snr': '10',
      };

      final gps = GpsData.fromJson(json);

      expect(gps.lat, '51.5074');
      expect(gps.lon, '-0.1278');
      expect(gps.fix, '3');
      expect(gps.alt, '15.2');
      expect(gps.course, '270');
      expect(gps.date, '27/04/2025');
      expect(gps.time, '12:00:00');
      expect(gps.rssi, '-85');
      expect(gps.snr, '10');
    });

    test('handles missing fields gracefully', () {
      final gps = GpsData.fromJson({'type': 'gps'});
      expect(gps.lat, '');
      expect(gps.lon, '');
    });
  });

  group('ChatMessage', () {
    test('default timestamp is set', () {
      final before = DateTime.now();
      final msg = ChatMessage(from: 'hiker', text: 'Hello!');
      final after = DateTime.now();
      expect(msg.from, 'hiker');
      expect(msg.text, 'Hello!');
      expect(msg.timestamp.isAfter(before) || msg.timestamp == before, isTrue);
      expect(msg.timestamp.isBefore(after) || msg.timestamp == after, isTrue);
    });

    test('custom timestamp is preserved', () {
      final ts = DateTime(2025, 1, 1, 9, 30);
      final msg = ChatMessage(from: 'base', text: 'Hi', timestamp: ts);
      expect(msg.timestamp, ts);
    });
  });
}

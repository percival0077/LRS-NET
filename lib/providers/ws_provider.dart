import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const _wsUrl = 'ws://192.168.4.1/ws';
const _reconnectDelay = Duration(seconds: 3);

class ChatMessage {
  final String from; // 'hiker' or 'base'
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.from, required this.text, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class GpsData {
  final String lat;
  final String lon;
  final String fix;
  final String alt;
  final String course;
  final String date;
  final String time;
  final String rssi;
  final String snr;

  const GpsData({
    required this.lat,
    required this.lon,
    required this.fix,
    required this.alt,
    required this.course,
    required this.date,
    required this.time,
    required this.rssi,
    required this.snr,
  });

  factory GpsData.fromJson(Map<String, dynamic> json) {
    return GpsData(
      lat: json['lat']?.toString() ?? '',
      lon: json['lon']?.toString() ?? '',
      fix: json['fix']?.toString() ?? '',
      alt: json['alt']?.toString() ?? '',
      course: json['course']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      rssi: json['rssi']?.toString() ?? '',
      snr: json['snr']?.toString() ?? '',
    );
  }
}

class WsProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;

  bool _connected = false;
  bool get connected => _connected;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  GpsData? _gpsData;
  GpsData? get gpsData => _gpsData;

  WsProvider() {
    _connect();
  }

  void _connect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      // connected will be set to true in _onData once we receive the first frame
    } catch (e) {
      _setConnected(false);
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    if (!_connected) {
      _setConnected(true);
    }
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String?;
      if (type == 'gps') {
        _gpsData = GpsData.fromJson(data);
        notifyListeners();
      } else if (type == 'chat') {
        final from = data['from']?.toString() ?? 'hiker';
        final text = data['text']?.toString() ?? '';
        _messages.add(ChatMessage(from: from, text: text));
        notifyListeners();
      }
    } catch (_) {
      // ignore malformed messages
    }
  }

  void _onError(Object error) {
    _setConnected(false);
    _scheduleReconnect();
  }

  void _onDone() {
    _setConnected(false);
    _scheduleReconnect();
  }

  void _setConnected(bool value) {
    if (_connected != value) {
      _connected = value;
      notifyListeners();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _subscription?.cancel();
      _channel?.sink.close();
      _connect();
    });
  }

  /// Send a chat message to the server.
  void sendMessage(String text) {
    if (!_connected || text.trim().isEmpty) return;
    final payload = jsonEncode({'type': 'chat', 'text': text.trim()});
    try {
      _channel?.sink.add(payload);
      // Show own message on the right (from = 'base')
      _messages.add(ChatMessage(from: 'base', text: text.trim()));
      notifyListeners();
    } catch (_) {
      _setConnected(false);
      _scheduleReconnect();
    }
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}

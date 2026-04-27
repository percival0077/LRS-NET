import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/ws_provider.dart';

class GpsScreen extends StatelessWidget {
  const GpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gps = context.select<WsProvider, GpsData?>((p) => p.gpsData);

    if (gps == null) {
      return const Center(
        child: Text(
          'Waiting for GPS data…',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'GPS Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  _Row('Latitude', gps.lat),
                  _Row('Longitude', gps.lon),
                  _Row('Fix', _fixLabel(gps.fix)),
                  _Row('Altitude', '${gps.alt} m'),
                  _Row('Course', '${gps.course}°'),
                  _Row('Date', gps.date),
                  _Row('Time', gps.time),
                  const Divider(height: 24),
                  const Text(
                    'Signal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Row('RSSI', '${gps.rssi} dBm'),
                  _Row('SNR', '${gps.snr} dB'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (gps.lat.isNotEmpty && gps.lon.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Open in Maps'),
                onPressed: () => _openMaps(context, gps.lat, gps.lon),
              ),
            ),
        ],
      ),
    );
  }

  String _fixLabel(String fix) {
    switch (fix) {
      case '0':
        return '0 – No fix';
      case '1':
        return '1 – No fix';
      case '2':
        return '2 – 2D fix';
      case '3':
        return '3 – 3D fix';
      default:
        return fix;
    }
  }

  Future<void> _openMaps(
      BuildContext context, String lat, String lon) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open maps')),
        );
      }
    }
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

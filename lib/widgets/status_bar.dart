import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ws_provider.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final connected = context.select<WsProvider, bool>((p) => p.connected);
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: connected ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 8),
          Text(
            connected ? 'Connected' : 'No signal',
            style: TextStyle(
              color: connected ? Colors.greenAccent : Colors.redAccent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

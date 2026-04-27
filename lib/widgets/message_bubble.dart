import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String from;
  final String text;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.from,
    required this.text,
    required this.timestamp,
  });

  bool get _isBase => from == 'base';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor =
        _isBase ? theme.colorScheme.primary : const Color(0xFF424242);
    final textColor = Colors.white;
    final align = _isBase ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = _isBase
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            _isBase ? 'Base' : 'Hiker',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: radius,
            ),
            child: Column(
              crossAxisAlignment:
                  _isBase ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(color: textColor, fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  _formatTime(timestamp),
                  style: TextStyle(
                    color: textColor.withOpacity(0.65),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

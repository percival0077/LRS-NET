import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/ws_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/gps_screen.dart';
import 'widgets/status_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WsProvider(),
      child: const LrsNetApp(),
    ),
  );
}

class LrsNetApp extends StatelessWidget {
  const LrsNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LRS-Net Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _tabIndex = 0;

  static const _tabs = [
    Tab(icon: Icon(Icons.chat), text: 'Chat'),
    Tab(icon: Icon(Icons.gps_fixed), text: 'GPS'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LRS-Net Chat'),
          bottom: TabBar(
            tabs: _tabs,
            onTap: (i) => setState(() => _tabIndex = i),
          ),
        ),
        body: Column(
          children: [
            const StatusBar(),
            Expanded(
              child: TabBarView(
                children: const [
                  ChatScreen(),
                  GpsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

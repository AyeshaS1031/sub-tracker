import 'package:flutter/material.dart';
import 'package:sub_tracker/theme.dart';
import 'package:sub_tracker/features/dashboard/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtrackr',
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}

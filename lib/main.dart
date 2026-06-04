import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/features/splash/screens/splash_screen.dart';
import 'package:sub_tracker/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>(SubscriptionRepository.boxName);
  final repo = SubscriptionRepository(box);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repo});

  final SubscriptionRepository repo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtrackr',
      theme: AppTheme.darkTheme,
      home: SplashScreen(repo: repo),
    );
  }
}

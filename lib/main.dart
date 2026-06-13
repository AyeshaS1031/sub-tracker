import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/features/splash/screens/splash_screen.dart';
import 'package:sub_tracker/theme.dart';
import 'package:sub_tracker/services/notifs_service.dart';

Future<SubscriptionRepository> _initRepo() async {
  final notifications = NotificationService();
  await notifications.init();

  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>(SubscriptionRepository.boxName);
  final settingsBox = await Hive.openBox<dynamic>(
    SubscriptionRepository.settingsBoxName,
  );
  final repo = SubscriptionRepository(box, settingsBox, notifications);

  for (final sub in repo.allSubscriptions()) {
    await notifications.schedule(
      sub
    );
    
  }

  return repo;
}

void main() {
  runApp(const SubtrackrApp());
}

class SubtrackrApp extends StatelessWidget {
  const SubtrackrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtrackr',
      theme: AppTheme.darkTheme,
      home: FutureBuilder<SubscriptionRepository>(
        future: _initRepo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to load app data.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.onSurface),
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.secondary),
              ),
            );
          }

          return SplashScreen(repo: snapshot.data!);
        },
      ),
    );
  }
}

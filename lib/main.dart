import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/features/splash/screens/splash_screen.dart';
import 'package:sub_tracker/theme.dart';

Future<SubscriptionRepository> _initRepo() async {
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>(SubscriptionRepository.boxName);
  final settingsBox =
      await Hive.openBox<dynamic>(SubscriptionRepository.settingsBoxName);
  return SubscriptionRepository(box, settingsBox);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SubtrackrApp());
}

class SubtrackrApp extends StatelessWidget {
  const SubtrackrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtrackr',
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
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

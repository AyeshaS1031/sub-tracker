import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/data/subscription_repository.dart';
import 'package:sub_tracker/features/add_subscription/screens/add_subscription_screen.dart';
import 'package:sub_tracker/features/dashboard/screens/dashboard_screen.dart';
import 'package:sub_tracker/features/settings/screens/settings_screen.dart';
import 'package:sub_tracker/features/view_subscriptions/screens/view_subscription.dart';
import 'package:sub_tracker/theme.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key, required this.repo});

  final SubscriptionRepository repo;

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _tab = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        repo: widget.repo,
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      ViewSubscriptionScreen(repo: widget.repo),
      SettingsScreen(repo: widget.repo),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer: Drawer(
        backgroundColor: AppTheme.surfaceContainerLow,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.surfaceContainer),
              child: Text(
                'SUBTRACKR',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.grid_view_rounded),
              title: const Text('Dashboard'),
              selected: _tab == 0,
              onTap: () {
                setState(() {
                  _tab = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_rounded),
              title: const Text('View Your Subscriptions'),
              selected: _tab == 1,
              onTap: () {
                setState(() {
                  _tab = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              selected: _tab == 2,
              onTap: () {
                setState(() {
                  _tab = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _tab, children: pages),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AddSubscriptionScreen(repo: widget.repo),
                  ),
                );
              },
              backgroundColor: AppTheme.secondary,
              foregroundColor: Colors.black,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) {
          setState(() {
            _tab = i;
          });
        },
        backgroundColor: AppTheme.surfaceContainerLow,
        selectedItemColor: AppTheme.secondary,
        unselectedItemColor: AppTheme.outline,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Subs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub_tracker/data/models/subscription.dart';
import 'package:sub_tracker/services/notifs_service.dart';

class SubscriptionRepository extends ChangeNotifier {
  SubscriptionRepository(this._box, this._settingsBox, this._notifications);

  final Box<dynamic> _box;
  final Box<dynamic> _settingsBox;
  final NotificationService _notifications;

  static const String boxName = 'subscriptions';
  static const String settingsBoxName = 'settings';

  static const List<String> currencyOptions = [r'$', '€', '£', 'LKR'];

  String get currencySymbol =>
      (_settingsBox.get('currency') as String?) ?? r'$';

  void setCurrency(String symbol) {
    _settingsBox.put('currency', symbol);
    notifyListeners();
  }

  String formatMoney(double amount, {int decimals = 2}) {
    return '$currencySymbol${amount.toStringAsFixed(decimals)}';
  }

  void _notify(Subscription sub) {
    _notifications.schedule(sub);
  }

  void clearAll() {
    _notifications.cancelAll();
    _box.clear();
    notifyListeners();
  }

  List<Subscription> _all() {
    final out = <Subscription>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        out.add(
          Subscription.fromMap(key.toString(), Map<String, dynamic>.from(raw)),
        );
      }
    }
    out.sort((a, b) => b.created.compareTo(a.created));
    return out;
  }

  List<Subscription> allSubscriptions() => _all();

  List<Subscription> activeSubscriptions() =>
      _all().where((s) => s.isActive).toList();

  void updateSubscription(Subscription sub) {
    _notify(sub);
    _box.put(sub.id, sub.toMap());
    notifyListeners();
  }

  void setActive(String id, bool isActive) {
    final subs = _all();
    final i = subs.indexWhere((s) => s.id == id);
    if (i < 0) return;
    updateSubscription(subs[i].copyWith(isActive: isActive));
  }

  void addSubscription({
    required String name,
    required double monthlyAmount,
    required SpendCategory category,
    bool isActive = true,
    DateTime? deadline,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final sub = Subscription(
      id: id,
      name: name,
      monthlyAmount: monthlyAmount,
      category: category,
      created: DateTime.now(),
      isActive: isActive,
      deadline: deadline,
    );
    _box.put(id, sub.toMap());
    _notify(sub);
    notifyListeners();
  }

  List<Subscription> upcomingDeadlines({int withinDays = 7}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = today.add(Duration(days: withinDays));
    return _all().where((s) {
      if (!s.isActive || s.deadline == null) return false;
      final due = DateTime(
        s.deadline!.year,
        s.deadline!.month,
        s.deadline!.day,
      );
      return !due.isBefore(today) && !due.isAfter(cutoff);
    }).toList()..sort((a, b) => a.deadline!.compareTo(b.deadline!));
  }

  double monthlyBurnTotal() {
    var sum = 0.0;
    for (final sub in _all()) {
      if (sub.isActive) sum += sub.monthlyAmount;
    }
    return sum;
  }

  int serviceCount() => activeSubscriptions().length;

  Map<SpendCategory, double> totalsByCategory() {
    final out = {
      SpendCategory.subscriptions: 0.0,
      SpendCategory.utilities: 0.0,
      SpendCategory.entertainment: 0.0,
    };
    for (final sub in _all()) {
      if (sub.isActive) {
        out[sub.category] = out[sub.category]! + sub.monthlyAmount;
      }
    }
    return out;
  }

  ({List<DateTime> months, List<double> amounts}) spendingLastSixMonths() {
    final now = DateTime.now();
    final months = <DateTime>[];
    final amounts = <double>[];
    final burn = monthlyBurnTotal();

    for (var i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      months.add(d);
      final sameMonth = d.year == now.year && d.month == now.month;
      amounts.add(sameMonth ? burn : 0);
    }

    return (months: months, amounts: amounts);
  }

  double averageFromBars(List<double> bars) {
    if (bars.isEmpty) return 0;
    final nz = bars.where((e) => e > 0).toList();
    if (nz.isEmpty) return 0;
    var s = 0.0;
    for (final x in nz) {
      s += x;
    }
    return s / nz.length;
  }
}

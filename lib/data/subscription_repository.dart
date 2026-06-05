import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub_tracker/data/models/subscription.dart';

/// Reads and writes subscriptions in Hive.
/// Screens never touch Hive directly — they call methods here.
class SubscriptionRepository extends ChangeNotifier {
  SubscriptionRepository(this._box, this._settingsBox);

  final Box<dynamic> _box;
  final Box<dynamic> _settingsBox;

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

  void clearAll() {
    _box.clear();
    notifyListeners();
  }

  List<Subscription> _all() {
    final out = <Subscription>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        out.add(Subscription.fromMap(key.toString(), Map<String, dynamic>.from(raw)));
      }
    }
    out.sort((a, b) => b.created.compareTo(a.created));
    return out;
  }

  List<Subscription> allSubscriptions() => _all();

  void addSubscription({
    required String name,
    required double monthlyAmount,
    required SpendCategory category,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final sub = Subscription(
      id: id,
      name: name,
      monthlyAmount: monthlyAmount,
      category: category,
      created: DateTime.now(),
    );
    _box.put(id, sub.toMap());
    notifyListeners();
  }

  double monthlyBurnTotal() {
    var sum = 0.0;
    for (final sub in _all()) {
      sum += sub.monthlyAmount;
    }
    return sum;
  }

  int serviceCount() => _box.length;

  Map<SpendCategory, double> totalsByCategory() {
    final out = {
      SpendCategory.subscriptions: 0.0,
      SpendCategory.utilities: 0.0,
      SpendCategory.entertainment: 0.0,
    };
    for (final sub in _all()) {
      out[sub.category] = out[sub.category]! + sub.monthlyAmount;
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

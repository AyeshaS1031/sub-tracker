import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum SpendCategory { subscriptions, utilities, entertainment }

extension SpendCategoryIx on SpendCategory {
  int get index => SpendCategory.values.indexOf(this);
}

class SubscriptionRepository extends ChangeNotifier {
  SubscriptionRepository(this._box);

  final Box<dynamic> _box;

  static const String boxName = 'subscriptions';

  Iterable<Map<String, dynamic>> _rows() sync* {
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        yield Map<String, dynamic>.from(raw);
      }
    }
  }

  List<Map<String, dynamic>> allSubscriptions() {
    return _rows().toList();
  }

  void addSubscription({
    required String name,
    required double monthlyAmount,
    required SpendCategory category,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _box.put(id, {
      'name': name,
      'amount': monthlyAmount,
      'category': category.index,
      'created': DateTime.now().millisecondsSinceEpoch,
    });
    notifyListeners();
  }

  double monthlyBurnTotal() {
    var sum = 0.0;
    for (final m in _rows()) {
      sum += (m['amount'] as num).toDouble();
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
    for (final m in _rows()) {
      final ci = (m['category'] as num).toInt().clamp(0, 2);
      final cat = SpendCategory.values[ci];
      out[cat] = out[cat]! + (m['amount'] as num).toDouble();
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

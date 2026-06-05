/// Category groups for spending breakdown on the dashboard.
enum SpendCategory { subscriptions, utilities, entertainment }

/// One subscription saved in Hive.
/// Every screen (add, view, dashboard) uses this same class.
class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.monthlyAmount,
    required this.category,
    required this.created,
  });

  final String id;
  final String name;
  final double monthlyAmount;
  final SpendCategory category;
  final DateTime created;

  /// Read a Hive map into a [Subscription].
  factory Subscription.fromMap(String id, Map<String, dynamic> map) {
    final categoryIndex = (map['category'] as num).toInt().clamp(0, 2);
    return Subscription(
      id: id,
      name: map['name'] as String,
      monthlyAmount: (map['amount'] as num).toDouble(),
      category: SpendCategory.values[categoryIndex],
      created: DateTime.fromMillisecondsSinceEpoch(
        (map['created'] as num).toInt(),
      ),
    );
  }

  /// Write this subscription back to a Hive map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': monthlyAmount,
      'category': category.index,
      'created': created.millisecondsSinceEpoch,
    };
  }

  String get categoryLabel {
    switch (category) {
      case SpendCategory.subscriptions:
        return 'Subscriptions';
      case SpendCategory.utilities:
        return 'Utilities';
      case SpendCategory.entertainment:
        return 'Entertainment';
    }
  }
}

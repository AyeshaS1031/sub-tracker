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
    this.isActive = true,
    this.deadline,
  });

  final String id;
  final String name;
  final double monthlyAmount;
  final SpendCategory category;
  final DateTime created;
  final bool isActive;
  final DateTime? deadline;

  
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
      isActive: map['isActive'] as bool? ?? true,
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['deadline'] as num).toInt(),
            )
          : null,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': monthlyAmount,
      'category': category.index,
      'created': created.millisecondsSinceEpoch,
      'isActive': isActive,
      if (deadline != null) 'deadline': deadline!.millisecondsSinceEpoch,
    };
  }

  Subscription copyWith({
    String? id,
    String? name,
    double? monthlyAmount,
    SpendCategory? category,
    DateTime? created,
    bool? isActive,
    DateTime? deadline,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      category: category ?? this.category,
      created: created ?? this.created,
      isActive: isActive ?? this.isActive,
      deadline: deadline ?? this.deadline,
    );
  }

  bool get isOverdue {
    if (deadline == null) return false;
    final today = DateTime.now();
    final due = DateTime(deadline!.year, deadline!.month, deadline!.day);
    final now = DateTime(today.year, today.month, today.day);
    return due.isBefore(now);
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

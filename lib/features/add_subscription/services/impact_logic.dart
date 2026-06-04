double computeImpactPercent({
  required double currentMonthlyBurn,
  required double newMonthlyAmount,
}) {
  final total = currentMonthlyBurn + newMonthlyAmount;
  if (total <= 0)
    return 0;
  else {
    return (newMonthlyAmount / total) * 100;
  }
}

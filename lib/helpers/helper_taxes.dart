import 'package:dart_asynchronous/models/account.dart';

double calculateTaxesByAccount(
    {required Account account, required double amount}) {
  Map<String, double> tax = {
    "1A": 0.05,
    "1B": 0.0033,
    "2A": 0.0025,
    "2B": 0.0001
  };
  if (amount >= 5000 && account.accountType != null) {
    return tax[account.accountType]! * amount;
  }
  return 0;
}

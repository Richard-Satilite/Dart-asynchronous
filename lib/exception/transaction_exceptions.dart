import 'package:dart_asynchronous/models/account.dart';

class SenderNotExistsException implements Exception {
  String message;
  String cause;
  SenderNotExistsException({this.message = "ID inválido", required this.cause});
}

class ReceiverNotExistsException implements Exception {
  String message;
  String cause;
  ReceiverNotExistsException(
      {this.message = "ID inválido", required this.cause});
}

class NotEnoughFundsException implements Exception {
  String message;
  Account cause;
  double amount;
  double taxes;

  NotEnoughFundsException(
      {this.message = "Saldo Insuficiente.",
      required this.cause,
      required this.amount,
      required this.taxes});
}

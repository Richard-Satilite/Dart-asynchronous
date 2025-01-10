import 'dart:async';
import 'package:dart_asynchronous/exception/transaction_exceptions.dart';
import 'package:dart_asynchronous/helpers/helper_taxes.dart';
import 'package:dart_asynchronous/models/account.dart';
import 'package:dart_asynchronous/models/transaction.dart';
import 'package:dart_asynchronous/services/account_service.dart';
import 'package:dart_asynchronous/services/api_endpoints.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:dart_asynchronous/api_key.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  Uuid _uuid = Uuid();
  String url = "${ApiEndpoints.base}/${ApiEndpoints.transactionEndPoint}";
  final AccountService _accountService = AccountService();

  Future<Transaction> makeTransaction(
      {required String idSender,
      required String idReceiver,
      required double amount}) async {
    List<Account> listAccount = await _accountService.getAll();

    Account sender = listAccount.firstWhere((acc) => acc.id == idSender,
        orElse: () => throw SenderNotExistsException(cause: idSender));
    Account receiver = listAccount.firstWhere((acc) => acc.id == idReceiver,
        orElse: () => throw ReceiverNotExistsException(cause: idReceiver));

    double tax = calculateTaxesByAccount(account: sender, amount: amount);

    if (sender.balance >= amount + tax) {
      sender.balance -= (amount + tax);
      receiver.balance += amount;
      _accountService.updateAccount(sender);
      _accountService.updateAccount(receiver);

      Transaction transaction = Transaction(
          id: _uuid.v1(),
          senderId: sender.id,
          receiverId: receiver.id,
          date: DateTime.now(),
          amount: amount,
          tax: tax);
      return transaction;
    } else {
      throw NotEnoughFundsException(cause: sender, amount: amount, taxes: tax);
    }
  }

  Future<List<Transaction>> getAll() async {
    Response response = await get(Uri.parse(url));
    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse['files']['transactions.json']['content']);
    List<Transaction> listTransactions = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapTransaction = dyn as Map<String, dynamic>;
      Transaction transaction = Transaction.fromMap(mapTransaction);
      listTransactions.add(transaction);
    }
    return listTransactions;
  }

  Future<Response> save(List<Transaction> listTransactions) async {
    List<Map<String, dynamic>> listContent = [];
    for (Transaction trs in listTransactions) {
      listContent.add(trs.toMap());
    }

    String content = json.encode(listContent);

    Response response = await patch(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $gistKey",
          "Content-type": "application/json",
          "X-GitHub-Api-Version": "2022-11-28"
        },
        body: json.encode({
          "description": "transactions.json",
          "public": true,
          "files": {
            "transactions.json": {"content": content}
          }
        }));
    return response;
  }

  addTransaction(Transaction transaction) async {
    List<Transaction> listTransactions = await getAll();
    listTransactions.add(transaction);

    Response response = await save(listTransactions);

    if (response.statusCode.toString()[0] == '2') {
      _streamController.add(
          "${DateTime.now()} | Requisição de adiçao de transação bem sucedida (${transaction.senderId} para ${transaction.receiverId})");
    } else {
      _streamController.add(
          "${DateTime.now()} | Falha na requisição de adição de transação (${transaction.senderId} para ${transaction.receiverId})");
    }
  }
}

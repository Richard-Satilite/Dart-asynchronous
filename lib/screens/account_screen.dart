import 'package:dart_asynchronous/exception/transaction_exceptions.dart';
import 'package:dart_asynchronous/models/transaction.dart';
import 'package:dart_asynchronous/services/transaction_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:dart_asynchronous/models/account.dart';
import 'package:dart_asynchronous/services/account_service.dart';
import 'package:dart_asynchronous/services/account_types.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();
  final TransactionService _transactionService = TransactionService();
  final Uuid _uuid = Uuid();
  void initializeStream() {
    _accountService.streamInfos.listen((event) => print(event));
  }

  void runChatBot() async {
    print("\nOlá, me chamo Ron! Chat Bot assistente");

    bool isRunning = true;
    while (isRunning) {
      print("\n\nComo posso te ajudar? (Digite o número desejado)");
      print("1 - Ver todas as contas.");
      print("2 - Adicionar uma conta.");
      print("3 - Realizar Transação\n");
      print("4 - Sair\n");
      String? input = stdin.readLineSync();
      if (input != null) {
        switch (input) {
          case "1":
            await _getAllAccounts();
            break;
          case "2":
            String? name, lastName, accountType, balance;
            double? parsedBalance;
            print("\nDigite o nome:");
            name = stdin.readLineSync();
            print("\nDigite o Sobrenome:");
            lastName = stdin.readLineSync();
            print("\nDigite o saldo:");
            balance = stdin.readLineSync();
            parsedBalance = balance != null ? double.tryParse(balance) : null;
            print("\nDigite o tipo de conta:");
            accountType = stdin.readLineSync();
            if (name != null &&
                lastName != null &&
                parsedBalance != null &&
                accountType != null &&
                Accounttypes.types.contains(accountType.toUpperCase())) {
              await _addAccount(
                  name, lastName, parsedBalance, accountType.toUpperCase());
            } else {
              print(
                  "\nUm ou mais valores digitados é(são) inválido(s)! Digite novamente");
            }
            break;
          case "3":
            String? idSender, idReceiver, amount;
            double? parsedAmount;
            print("\nDigite o ID do remetente:");
            idSender = stdin.readLineSync();
            print("\nDigite o ID do destinatário:");
            idReceiver = stdin.readLineSync();
            print("\nDigite o valor a ser transferido:");
            amount = stdin.readLineSync();
            parsedAmount = amount != null ? double.tryParse(amount) : null;
            if (idSender != null &&
                idReceiver != null &&
                parsedAmount != null) {
              try {
                Transaction transaction =
                    await _transactionService.makeTransaction(
                        idSender: idSender,
                        idReceiver: idReceiver,
                        amount: parsedAmount);

                _transactionService.addTransaction(transaction);
              } on SenderNotExistsException catch (e) {
                print(e.message);
                print("ID remetente: ${e.cause}");
              } on ReceiverNotExistsException catch (e) {
                print(e.message);
                print("ID destinatário: ${e.cause}");
              } on NotEnoughFundsException catch (e) {
                print(e.message);
                print(
                    "${e.cause.name}\t|\tSaldo: ${e.amount} < ${e.amount + e.taxes}");
              } on Exception {
                print("Erro ao realizar transação. Tente mais tarde!");
              } finally {
                print(
                    "\n${DateTime.now()} | Tentativa de transação entre contas\n");
              }
            } else {
              print(
                  "\nUm ou mais informações digitados é(são) inválido(s)! Digite novamente");
            }
            break;
          case "4":
            isRunning = false;
            print("Até mais!");
            break;
          default:
            print("\nOpção inválida! Digite apenas umas das opções.");
        }
      }
    }
  }

  Future<void> _getAllAccounts() async {
    try {
      List<Account> listAccounts = await _accountService.getAll();
      for (Account acc in listAccounts) {
        print(acc.toString());
      }
    } on ClientException catch (clientException) {
      print("Não foi possível realizar contato com o servidor.");
      print("Error:\n${clientException.message}\n${clientException.uri}\n");
    } on Exception {
      print("\nNão foi possível realizar a conexão com os dados!");
      print("Tente novamente mais tarde.\n");
    } finally {
      print("\n${DateTime.now()} | Tentativa de consulta\n");
    }
  }

  Future<void> _addAccount(
      String name, String lastName, double balance, String accountType) async {
    Account acc = Account(
        id: _uuid.v1(),
        name: name,
        lastName: lastName,
        balance: balance,
        accountType: accountType);
    try {
      await _accountService.addAccount(acc);
      print("Conta do ${acc.name} ${acc.lastName} adicionada!");
    } on ClientException catch (e) {
      print("\nNão foi possível realizar contato com o servidor.");
      print("Error: ${e.message}\n${e.uri}\n");
    } on Exception {
      print("\nNão foi possível realizar a conexão com os dados!");
      print("Tente novamente mais tarde.\n");
    } finally {
      print("\n${DateTime.now()} | Tentativa de adição de conta\n");
    }
  }
}

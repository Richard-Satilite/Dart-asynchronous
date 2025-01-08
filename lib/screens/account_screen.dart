import 'dart:io';
import 'package:dart_asynchronous/models/account.dart';
import 'package:dart_asynchronous/services/account_service.dart';

class AccountScreen {
  AccountService _accountService = AccountService();

  void initializeStream() {
    _accountService.streamInfos.listen((event) => print(event));
  }

  void runChatBot() async {
    print("Olá, me chamo Ron! Chat Bot assistente");

    bool isRunning = true;
    while (isRunning) {
      print("Como posso te ajudar? (Digite o número desejado)");
      print("1 - Ver todas as contas.");
      print("2 - Adicionar uma conta de exemplo.");
      print("3 - Sair\n");
      String? input = stdin.readLineSync();
      if (input != Null) {
        switch (input) {
          case "1":
            await _getAllAccounts();
            break;
          case "2":
            await _addExampleAccount();
            break;
          case "3":
            isRunning = false;
            print("Até mais!");
            break;
          default:
        }
      }
    }
  }

  Future<void> _getAllAccounts() async {
    List<Account> listAccounts = await _accountService.getAll();
    for (Account acc in listAccounts) {
      print("\n${acc.id}\n${acc.name}\n${acc.lastName}\n${acc.balance}\n");
    }
  }

  Future<void> _addExampleAccount() async {
    Account exampleAcc =
        Account(id: "NEWID", name: "Jhon", lastName: "Doe", balance: 699.89);

    _accountService.addAccount(exampleAcc);
    print("Conta do ${exampleAcc.name} ${exampleAcc.lastName} adicionada!");
  }
}

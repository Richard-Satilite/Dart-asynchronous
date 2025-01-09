import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:dart_asynchronous/models/account.dart';
import 'package:dart_asynchronous/services/account_service.dart';

class AccountScreen {
  AccountService _accountService = AccountService();
  Uuid _uuid = Uuid();
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
      print("3 - Sair\n");
      String? input = stdin.readLineSync();
      if (input != null) {
        switch (input) {
          case "1":
            await _getAllAccounts();
            break;
          case "2":
            String? name, lastName;
            double? parsedBalance;
            print("\nDigite o nome:");
            name = stdin.readLineSync();
            print("\nDigite o Sobrenome:");
            lastName = stdin.readLineSync();
            print("\nDigite o saldo:");
            parsedBalance = double.tryParse(stdin.readLineSync()!);
            if (name != null && lastName != null && parsedBalance != null) {
              await _addAccount(name, lastName, parsedBalance);
            } else {
              print(
                  "\nUm ou mais valores digitados é(são) inválido(s)! Digite novamente");
            }
            break;
          case "3":
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
        print("\n${acc.id}\n${acc.name}\n${acc.lastName}\n${acc.balance}\n");
      }
    } on ClientException catch (clientException) {
      print("Não foi possível realizar contato com o servidor.");
      print("Error:\n${clientException.message}\n${clientException.uri}\n");
    } on Exception {
      print("\nNão foi possível realizar a conexão com os dados!");
      print("Tente novamente mais tarde.\n");
    } finally {
      print("${DateTime.now()} | Tentativa de consulta");
    }
  }

  Future<void> _addAccount(String name, String lastName, double balance) async {
    Account acc = Account(
        id: _uuid.v1(), name: name, lastName: lastName, balance: balance);
    await _accountService.addAccount(acc);
    print("Conta do ${acc.name} ${acc.lastName} adicionada!");
  }
}

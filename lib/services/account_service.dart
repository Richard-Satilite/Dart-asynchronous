import 'dart:async';
import 'package:dart_asynchronous/api_key.dart'; //THIS PACKAGE IS ONLY AVAIABLE FOR THE OWNER
import 'package:dart_asynchronous/services/api_endpoints.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:dart_asynchronous/models/account.dart';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url;

  AccountService(
      {this.url = "${ApiEndpoints.base}/${ApiEndpoints.accEndPoint}"});

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    _streamController.add("${DateTime.now()} | Requisição de leitura");
    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse['files']['accounts.json']['content']);
    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }
    return listAccounts;
  }

  Future<Response> save(List<Account> listAccounts) async {
    List<Map<String, dynamic>> listContent = [];
    for (Account acc in listAccounts) {
      listContent.add(acc.toMap());
    }

    String content = json.encode(listContent);

    Response response = await patch(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $gistKey",
          "Content-type": "application/json",
          "X-GitHub-Api-Version": "2022-11-28"
        },
        body: json.encode({
          "description": "accounts.json",
          "public": true,
          "files": {
            "accounts.json": {"content": content}
          }
        }));
    return response;
  }

  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    Response response = await save(listAccounts);

    if (response.statusCode.toString()[0] == '2') {
      _streamController.add(
          "${DateTime.now()} | Requisição de adiçao bem sucedida (${account.name})");
    } else {
      _streamController
          .add("${DateTime.now()} | Falha na requisição (${account.name})");
    }
  }

  Future<Account> getById(String id) async {
    List<Account> listAccounts = await getAll();
    return listAccounts.firstWhere((Account acc) => acc.id == id,
        orElse: () => throw Exception("Account with id $id not found."));
  }

  void updateAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    List<Map<String, dynamic>> listContent = [];
    for (Account acc in listAccounts) {
      if (acc.id == account.id) {
        acc.name = account.name;
        acc.lastName = account.lastName;
        acc.balance = account.balance;
        acc.accountType = account.accountType;
      }
      listContent.add(acc.toMap());
    }

    Response response = await save(listAccounts);

    if (response.statusCode.toString()[0] == '2') {
      _streamController
          .add("${DateTime.now()} | Alteração bem sucedida (${account.name})");
    } else {
      _streamController.add(
          "${DateTime.now()} | Falha na requisição para alteração (${response.statusCode})");
    }
  }

  void deleteAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.remove(account);
    List<Map<String, dynamic>> listContent = [];
    for (Account acc in listAccounts) {
      listContent.add(acc.toMap());
    }

    Response response = await save(listAccounts);

    if (response.statusCode.toString()[0] == '2') {
      _streamController
          .add("${DateTime.now()} | Delete bem sucedido (${account.name})");
    } else {
      _streamController.add(
          "${DateTime.now()} | Falha na requisição para delete (${response.statusCode})");
    }
  }
}

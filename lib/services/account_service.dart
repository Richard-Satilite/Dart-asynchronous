import 'dart:async';
import 'package:dart_asynchronous/api_key.dart'; //THIS PACKAGE IS ONLY AVAIABLE FOR THE OWNER
import 'package:http/http.dart';
import 'dart:convert';
import 'package:dart_asynchronous/models/account.dart';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  String url =
      "https://gist.githubusercontent.com/Richard-Satilite/2a58c22ad081f34ad45cfc5b87471730/raw/da939ba6dc9ec158c711ebfa8531d7928643effe/accounts.json";

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    _streamController.add("${DateTime.now()} | Requisição de leitura");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse["files"]["accounts.json"]["content"]);

    List<Account> listAccounts = [];
    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account acc in listAccounts) {
      listContent.add(acc.toMap());
    }
    String content = json.encode(listContent);

    Response response = await post(Uri.parse(url),
        headers: {"Authorization": "Bearer $gistKey"},
        body: json.encode({
          "description": "accounts.json",
          "public": true,
          "files": {
            "accounts.json": {"content": content}
          }
        }));
    if (response.statusCode.toString()[0] == '2') {
      _streamController.add(
          "${DateTime.now()} | Requisição de adiçao bem sucedida (${account.name})");
    } else {
      _streamController
          .add("${DateTime.now()} | Falha na requisição (${account.name})");
    }
  }
}

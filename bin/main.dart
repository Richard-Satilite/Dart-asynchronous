import 'package:dart_asynchronous/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  sendDataAsync(
      {"id": "NEWID", "name": "async", "lastName": "test", "balance": 400.00});
}

Future<List<dynamic>> requestAsync() async {
  String url =
      "https://gist.githubusercontent.com/Richard-Satilite/2a58c22ad081f34ad45cfc5b87471730/raw/da939ba6dc9ec158c711ebfa8531d7928643effe/accounts.json";

  Response response = await get(Uri.parse(url));

  return json.decode(response.body);
}

sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestAsync();
  listAccounts.add(mapAccount);
  String content = json.encode(listAccounts);

  String url = "https://api.github.com/gists/2a58c22ad081f34ad45cfc5b87471730";
  Response response = await post(Uri.parse(url),
      headers: {"Authorization": "Bearer $gistKey"},
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content}
        }
      }));
  print(response.statusCode);
}

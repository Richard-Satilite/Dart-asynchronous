import 'package:http/http.dart';

void main() {
  requestData();
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/Richard-Satilite/2a58c22ad081f34ad45cfc5b87471730/raw/da939ba6dc9ec158c711ebfa8531d7928643effe/accounts.json";
  Future<Response> futResponse = get(Uri.parse(url));

  futResponse.then(
    (Response response) {
      print(response.body);
    },
  );
}

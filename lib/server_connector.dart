import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ServerConnector {
  const ServerConnector();
  final String server = "http://185.146.3.41:8000";

  Future<dynamic> getPlayerId() async {
    try {
      var response = await http.get(Uri.parse("$server/generate_player_id/"));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print("$e");
      return null;
    }
  }

  Future<dynamic> chekConnect() async{
    final uri =
    Uri.http(server, '/');
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    print(response);
  }

  Future<dynamic> getCheckUniqueData(String mail, String phone) async {
    print("!!!!!!!!!!!!!!!!!!!!1");
    var response = await http.post(
      Uri.parse("$server/check_unique_data/"),
      headers: {"Content-type": "application/json"},
      body: json.encode({
        "email": mail,
        "phone": phone,
      }),
    );
    print("!!!!!!!!!!!!!");
    print(response.statusCode);
    return response;
    // try {
    //
    // } catch (e) {
    //   return "$e";
    // }
  }

  Future<dynamic> postData(
      String name,
      String lastName,
      String photoUrl,
      String phoneNumber,
      String email,
      int playerNumber,
      String gender,
      int playerHeight) async {
    try {
      var response = await http.post(
        Uri.parse("$server/register_new_player/"),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "name": name,
          "last_name": lastName,
          "photo_url": photoUrl,
          "phone_number": phoneNumber,
          "email": email,
          "player_number": playerNumber,
          "gender": gender,
          "register_point": 1,
          "player_height": playerHeight
        }),
      );
      print(response.body);
      return response.body;
    } catch (e) {
      return "$e";
    }
  }

  Future<String> sendImage(path) async {
    try{
      var postUri = Uri.parse("$server/upload_client_photo/1");

      http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'file', path);

      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();

      return response.stream.bytesToString();
    } catch (e) {
      return "$e";
    }
  }

}

import 'package:http/http.dart';
import 'dart:convert';

class ServerConnector {
  const ServerConnector();
  final String server = "http://127.0.0.1:8000";

  Future<dynamic> getPlayerId() async {
    try {
      var response = await get(Uri.parse("$server/generate_player_id/"));
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

  Future<dynamic> postData(
      String id,
      String name,
      String lastName,
      String photoUrl,
      String phoneNumber,
      String email,
      int playerNumber,
      String gender) async {
    try {
      var response = await post(
        Uri.parse("$server/register_new_player/"),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "id": id,
          "name": name,
          "last_name": lastName,
          "photo_url": photoUrl,
          "phone_number": phoneNumber,
          "email": email,
          "player_number": playerNumber,
          "gender": gender,
          "register_point": 0
        }),
      );
      return response.statusCode;
    } catch (e) {
      return "$e";
    }
  }
}

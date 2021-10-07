import 'package:http/http.dart' as http;
import 'package:rest_api_login_xp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Api {

  SharedPreferences? sharedPreferences;
  String _baseUrl = 'https://api.connectilib.ascan.io';

  // AUTHENTICATION
  /// Refresh token at each connection
  Future<void> refreshToken() async {
    /// Prepare post refreshing request
    String _requestUrl = '/api/v2/token/refresh';
    sharedPreferences = await SharedPreferences.getInstance();
    // print(sharedPreferences!.getString(kTokenKey)!);
    Map<String, String> data = {
      // kRefreshTokenKey: sharedPreferences!.getString(kTokenKey)!,
      kRefreshTokenKey: sharedPreferences!.getString(kRefreshTokenKey)!,
    };

    final response = await http.post(
        Uri.parse('$_baseUrl$_requestUrl'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(data)
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print('RefreshToken: ${response.statusCode}');
      throw Exception('Error refreshing token');
    }

  }



  Future<void> log(String email, String password) async {

    String _requestUrl = '/api/v2/shop/authentication-token';
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      Map<String, String> data = {'email': email, 'password': password};
      var jsonData;
      final response = await http.post(Uri.parse('$_baseUrl$_requestUrl'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        /// OK
        jsonData = json.decode(response.body);
        print(jsonData);
        sharedPreferences!.setString(kTokenKey, jsonData[kTokenKey]);
        sharedPreferences!.setString(kRefreshTokenKey, jsonData[kRefreshTokenKey]);
      } else if (response.statusCode == 500) {
        print('Oops une erreur est survenue de notre côté');
      } else {
        response.body.isNotEmpty
            ? print('Response: ${jsonDecode(response.body)}')
            : print('No response');
        throw Exception();
      }
    } on Exception catch (error) {
      print(error);
    }
  }

  Future<void> getCurrentUser() async {
    try {
      print('GetCurrentUser OK');
      refreshToken();
    } catch (error) {
      print(error);
      throw Exception();
    }
  }
}

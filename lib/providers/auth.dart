
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marketplace/model/http_exception.dart';

class Auth extends ChangeNotifier {
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCM8Il8uKi-Z0i1g9PCosvIrXzeT63RQEM";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'email': email, 'password': password},
        ),
      );
      final responseData = json.decode(response.body);
      // final errMessage = (responseData['error']['message']);
      // print('error message');
      // print('got here ${responseData['error']['message']}');
      if (responseData['error'] != null) {
        print('error thrown');
        throw HttpException(responseData['error']['message']);
      }
      // print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signIn');
  }
}

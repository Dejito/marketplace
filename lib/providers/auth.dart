
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marketplace/model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {

  DateTime? _expiryDate;
  String? _token;
  String? _userId;
  bool isSetLoginToken = false;
  String loginToken = "";
  Timer? _authTimer;

  // bool? get isAuth {
  //   return token != null;
  // }

  void get token {
    if (_token != null && _expiryDate!.isAfter(DateTime.now()) && _userId != null ) {
      isSetLoginToken = true;
      // return loginToken;
    } else {
      return ;
    }
  }

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
      print(">>>>>> $responseData");
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _userId = responseData['localId'];
      _token = responseData['idToken'];
      loginToken = responseData['idToken'];
      _expiryDate = DateTime.now().add(const Duration(hours: 1));
      token;
      notifyListeners();
      // print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

}

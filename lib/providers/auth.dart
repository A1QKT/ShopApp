import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exeption.dart';
import '../constant/const.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTime;
  String get getToken {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get getUserId {
    return _userId;
  }

  bool get getIsAuth {
    return _token != null;
  }

  Future<void> addAccount(String email, String password) async {
    final Uri url = Uri.parse(authAPISignup);
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(response);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final Uri url = Uri.parse(authAPILogin);
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final errorMessage = json.decode(response.body) as Map<String, dynamic>;
      if (errorMessage['error'] != null) {
        throw HttpExeption(message: errorMessage['error']['message']);
      }
      // print(errorMessage['expiresIn']);
      _token = errorMessage['idToken'];
      _userId = errorMessage['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(errorMessage['expiresIn'])));
      autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      pref.setString(
          "userData",
          json.encode({
            "token": _token,
            "userId": _userId,
            "expiryDate": _expiryDate.toIso8601String(),
          }));
      print("loadingcomplete");
      print(json.decode(pref.getString("userData")));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> isAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    print(pref.getString('userData'));
    if (!pref.containsKey("userData")) {
      return false;
    }
    final extractData =
        json.decode(pref.getString("userData")) as Map<String, dynamic>;
    if (DateTime.parse(extractData["expiryDate"]).isBefore(DateTime.now()))
      return false;
    _token = extractData["token"];
    _userId = extractData["userId"];
    _expiryDate = DateTime.parse(extractData["expiryDate"]);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    if (_authTime != null) {
      _authTime.cancel();
      _authTime = null;
    }
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autoLogout() {
    int time = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: time), logout);
  }
}

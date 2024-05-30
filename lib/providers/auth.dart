import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer _authTimer = Timer(Duration(seconds: 10), () {});

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token as String;
    }
    return '';
  }

  String get userId {
    return _userId as String;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAWo0XR6Q8fys_0gJewvdB3CfXvZxDn5hI');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'returnSecureToken': true,
          'email': email,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   'token': _token,
      //   'useId': _userId,
      //   'expiryDate': _expiryDate!.toIso8601String(),
      // });
      // prefs.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData = json.decode(prefs.getString('userData') as String)
  //       as Map<String, Object>;
  //   final expiryDate =
  //       DateTime.parse(extractedUserData['expiryDate'] as String);
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'] as String;
  //   _userId = extractedUserData['userId'] as String;
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   return true;
  // }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = '';
    _expiryDate = null;
    _userId = '';
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != Timer(Duration(seconds: 10), () {})) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

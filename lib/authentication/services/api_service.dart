import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline/authentication/models/rest/api_user.dart';
import 'package:offline/authentication/models/rest/token.dart';
import 'dart:convert';

import 'package:offline/config/constants.dart';


class ApiService {

  Future<String?> getToken(String email, String password) async {
    String url = Constants.tokenUrl;
    debugPrint(url);
    try {
      final Response response = await post(Uri.parse(url), body: {
        "email": email,
        "password": password,
        "device_name": "mobile"
      });
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        debugPrint(response.body);
        return Token.fromJson(json.decode(response.body)).token;
      } else {
        return "";
      }
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<ApiUser?> getUser(String token) async {
    String url = Constants.userUrl;
    try {
      final Response response = await get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return ApiUser.fromJson(json.decode(response.body));
      }
    }catch(e){
      return null;
    }
    return null;
  }

}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
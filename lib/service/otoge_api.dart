import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:otoge_mobile_app/model/store.dart';

import 'package:otoge_mobile_app/extension/response_extension.dart';

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class OtogeApi {
  OtogeApi();

  late final http.Client _client = http.Client();
  late final String _apiUrl = dotenv.env['OTOGE_API_URL'] ?? '';

  Future<List<Store>> searchByPosition(double lat, double lng) async {
    var url = Uri.https(_apiUrl, '/store/searchByPosition', {
      'lat': lat.toString(),
      'lng': lng.toString(),
    });

    var response = await _client.get(url);
    return _deserialize(response);
  }

  Future<List<Store>> searchByText(String text) async {
    var url = Uri.https(_apiUrl, '/store/searchByText', {
      'query': text
    });

    var response = await _client.get(url);
    return _deserialize(response);
  }

  void close() {
    _client.close();
  }

  List<Store> _deserialize(http.Response response) {
    if (!response.success) {
      throw HttpException(response.statusCode, response.body);
    }

    Iterable data = jsonDecode(response.body);
    return data.map((store)=> Store.fromJson(store)).toList();
  }
}
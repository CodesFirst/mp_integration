import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

import 'version.dart';

class MPRestClient {
  final String baseUrl = 'api.mercadopago.com';
  final String mineJson = 'application/json';
  final String mineForm = 'application/x-www-form-urlencoded';

  MPRestClient();

  String get _makeAgent => 'MercadoPago Dart SDK v$sdkVersion';

  Map<String, String> get _defaultHeader {
    return {
      'User-Agent': _makeAgent,
      'Accept': mineJson,
    };
  }

  Uri _makeURL(String uri, [Map<String, String>? params]) {
    return Uri.https(baseUrl, uri, params);
  }

  Map<String, String> _makeHeaders({
    Map<String, String>? extraHeaders,
  }) {
    if (extraHeaders != null) return _defaultHeader..addAll(extraHeaders);
    return _defaultHeader;
  }

  Future<Map<String, dynamic>> get(
    String uri, [
    Map<String, String>? params,
  ]) async {
    final response = await http.get(_makeURL(uri, params), headers: _makeHeaders());

    return {
      'status': response.statusCode,
      'response': json.decode(response.body),
    };
  }

  Future<Map<String, dynamic>> post(
    String uri, {
    Map<String, dynamic> data = const {},
    Map<String, String>? params,
    String? contentType,
  }) async {
    final response = await http.post(_makeURL(uri, params), headers: _makeHeaders(extraHeaders: {'Content-type': contentType ?? mineJson}), body: json.encode(data));

    return {
      'status': response.statusCode,
      'response': json.decode(response.body),
    };
  }

  Future<Map<String, dynamic>> put(
    String uri, {
    Map<String, dynamic> data = const {},
    Map<String, String>? params,
    String? contentType,
  }) async {
    final response = await http.put(_makeURL(uri, params), headers: _makeHeaders(extraHeaders: {'Content-type': contentType ?? mineJson}), body: json.encode(data));

    return {
      'status': response.statusCode,
      'response': json.decode(response.body),
    };
  }

  Future<Map<String, dynamic>> delete(
    String uri, {
    Map<String, String> params = const {},
  }) async {
    final response = await http.delete(_makeURL(uri, params), headers: _makeHeaders());

    return {
      'status': response.statusCode,
      'response': json.decode(response.body),
    };
  }
}

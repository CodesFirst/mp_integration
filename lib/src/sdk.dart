import 'dart:core';

import 'rest_client.dart';

class MP {
  String? _clientId;
  String? _clientSecret;

  String? _accessToken;
  final _restClient = MPRestClient();

  MP(this._clientId, this._clientSecret);

  MP.fromAccessToken(this._accessToken);

  /// Set access token
  /// return void
  void setAccessToken(String token) {
    _accessToken = token;
  }

  /// Get access token
  /// return Future<String>
  Future<String?> getAccessToken() async {
    if (_accessToken != null) {
      return _accessToken;
    }

    Map<String, String?> dataAppClient = {
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'grant_type': 'client_credentials',
    };

    var accessData = await _restClient.post('/oauth/token', data: dataAppClient, contentType: _restClient.mineForm);

    if (accessData['status'] == 200) {
      _accessToken = accessData['response']['access_token'];
      return _accessToken;
    }
    return null;
  }

  Future<Map<String, String>?> _getAccessTokenParam() async {
    String? accessToken = await getAccessToken();
    return accessToken != null ? {'access_token': accessToken} : null;
  }

  /// Get information for specific payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getPayment(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.get('/v1/payments/$id', params);
  }

  /// Get information for specific authorized payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getAuthorizedPayment(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.get('/authorized_payments/$id', params);
  }

  /// Refund accredited payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> refundPayment(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.post('/v1/payments/id/refunds', params: params, data: {});
  }

  /// Cancel pending payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> cancelPayment(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.put('/v1/payments/$id', params: params, data: {"status": "cancelled"});
  }

  /// Search payments according to filters, with pagination
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> searchPayment(Map<String, String> filters, {int offset = 0, int limit = 0}) async {
    Map<String, String>? params = await _getAccessTokenParam();
    if (params != null) filters.addAll(params);
    filters
      ..addAll({'offset': '$offset'})
      ..addAll({'limit': '$limit'});
    return _restClient.get('/v1/payments/search', filters);
  }

  /// Create a checkout preference
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> createPreference(Map<String, dynamic> preference) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.post('/checkout/preferences', params: params, data: preference);
  }

  /// Update a checkout preference
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> updatePreference(String id, Map<String, dynamic> preference) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.put('/checkout/preferences/${id}', params: params, data: preference);
  }

  /// Get a checkout preference
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getPreference(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.get('/checkout/preferences/$id', params);
  }

  /// Create a preapproval payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> createPreapprovalPayment(Map<String, dynamic> payment) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.post('/preapproval/', params: params, data: payment);
  }

  /// Get a preapproval payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getPreapprovalPayment(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.get('/preapproval/$id', params);
  }

  /// Update a preapproval payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> updatePreapprovalPayment(String id, Map<String, dynamic> payment) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.put('/preapproval/$id', params: params, data: payment);
  }

  /// Cancel preapproval payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> cancelPreapprovalPayment(String id) async {
    Map<String, String>? params = await _getAccessTokenParam();
    return _restClient.put('/preapproval/$id', params: params, data: {"status": "cancelled"});
  }

  /// Generic resource get
  /// Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> get(
    String uri, {
    Map<String, String>? params,
    bool authenticate = true,
  }) async {
    Map<String, String> extras = {};
    if (authenticate) {
      Map<String, String>? pToken = await _getAccessTokenParam();
      if (pToken != null) extras.addAll(pToken);
    }
    if (params != null) extras.addAll(params);
    return _restClient.get(uri, extras);
  }

  /// Generic resource post
  /// Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> post(
    String uri, {
    Map<String, dynamic> data = const {},
    Map<String, String>? params,
  }) async {
    Map<String, String> extras = {};
    Map<String, String>? pToken = await _getAccessTokenParam();
    if (pToken != null) extras.addAll(pToken);
    if (params != null) extras.addAll(params);
    return _restClient.post(uri, data: data, params: extras);
  }

  /// Generic resource put
  /// Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> put(
    String uri, {
    Map<String, dynamic> data = const {},
    Map<String, String>? params,
  }) async {
    Map<String, String> extras = {};
    Map<String, String>? pToken = await _getAccessTokenParam();
    if (pToken != null) extras.addAll(pToken);
    if (params != null) extras.addAll(params);
    return _restClient.put(uri, data: data, params: extras);
  }

  /// Generic resource delete
  /// Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> delete(
    String uri, {
    Map<String, String>? params,
  }) async {
    Map<String, String> extras = {};
    Map<String, String>? pToken = await _getAccessTokenParam();
    if (pToken != null) extras.addAll(pToken);
    if (params != null) extras.addAll(params);
    return _restClient.delete(uri, params: extras);
  }
}

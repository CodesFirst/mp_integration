import 'package:flutter/foundation.dart';
import 'package:mp_integration/mp_integration.dart';

void main() async {
  var mp = MP('CLIENT_ID', 'CLIENT_SECRET');

  String? token = await mp.getAccessToken();

  if (kDebugMode) {
    print('Mercadopago token $token');
  }
}

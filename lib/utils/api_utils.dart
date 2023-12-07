import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';

class ApiUtils {
  static Map<String, String> getHeaders() => {
        'Authorization': 'Bearer ${_getToken()}'
      };

  static String? _getToken() {
    String fullToken = Hive.box(hive).get("token", defaultValue: "") ?? "";
    final values = fullToken.split('|');
    final token = values.length > 1 ? values[1] : null;
    if (kDebugMode) {
      print(fullToken);
    }
    /*print(token);
    print(token);
    print(fullToken);*/
    return token;
  }
}

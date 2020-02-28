import 'dart:convert';

class Criptografia {
  static String encode(String data) {
    return base64Url.encode(utf8.encode(data));
  }
  static String decode(String data) {
    return utf8.decode(base64Url.decode(data));
  }
}
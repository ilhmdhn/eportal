import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:eportal/key/public_key.dart';

class Decoder{
  static jwtDecoder(String token){
    final publicKey = PublicKey.rsaPublicKey();
    final data = JWT.verify(token, publicKey);
    return jsonDecode(data.payload);
  }
}
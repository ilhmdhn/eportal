import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:eportal/key/public_key.dart';
import 'dart:convert';

class Decoder{
  static jwtDecoder(String token){
    final publicKey = PublicKey.rsaPublicKey();
    final data = JWT.verify(token, publicKey);
    print(data.payload.toString());
    return data.payload;
  }
}
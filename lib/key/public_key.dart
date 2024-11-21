import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class PublicKey{
  static RSAPublicKey rsaPublicKey(){
    return RSAPublicKey('''
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8pX+9SnNvQ9rkHG/W298
MAnJKnE9o+F99+U2irxJfvyWWWpmn+hYK0IxL6moqef27tKhxeLzWStJf5U+ote+
1dbfr60+weZD3F/GXSKLdPb+jM8IDCE9l6pIK7JEfEJQsBNWSiJxkH0+mfYc/BG5
87ZaXKg3XXqC+kPoU4RSKhJkrvD0eow2B51alaDyYKcQ4rMippEAyxVjEeaz3YvM
nDTDdCTX0E6sVKGfu9VJNjmkI6EzknGgjRMlQ1NLiIt3EAzRf2h/aXFXG+wQQJU0
XjgPOW/mSOqq8iNlCa6dLjkpknMFL4fuhxYSe0IC2Wt4pWOVFGNkCiaiPRV+DULj
DwIDAQAB
-----END PUBLIC KEY-----
''');
  }
}
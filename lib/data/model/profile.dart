import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/key/decoder.dart';

class Profile {
  String nip;
  String name;
  String email;
  String jabatan;
  String department;
  String employee;
  String signature;
  String outlet;

  Profile({
    required this.nip,
    required this.name,
    required this.email,
    required this.jabatan,
    required this.department,
    required this.employee,
    required this.signature,
    required this.outlet,
  });

  static Profile getProfile() {
      final key = SharedPreferencesData.getKey();
      final encodedKey = Decoder.jwtDecoder(key!);
      return Profile(
        nip: encodedKey['nip'],
        name: encodedKey['name'],
        email: encodedKey['email'],
        jabatan: encodedKey['jabatan'],
        department: encodedKey['departemen'],
        employee: encodedKey['emp_date'],
        signature: encodedKey['signature'],
        outlet: encodedKey['outlet']
      );
  }
}

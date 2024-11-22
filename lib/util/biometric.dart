import 'package:eportal/util/toast.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  Future<bool> requestFingerprintAuth() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      // final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (!canAuthenticateWithBiometrics || !canAuthenticate) {
        ShowToast.error('perangkat tidak didukung');
        return false;
      }

      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Verifikasi Biometric Diperlukan',
            options: const AuthenticationOptions(biometricOnly: true));
        return didAuthenticate;
      } catch (e) {
        ShowToast.error(e.toString());
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

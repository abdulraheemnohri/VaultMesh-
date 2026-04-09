import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  static Future<bool> authenticate() async {
    final localAuth = LocalAuthentication();
    try {
      return await localAuth.authenticate(
        localizedReason: 'Authenticate to access VaultMesh',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
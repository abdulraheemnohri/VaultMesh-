import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultmesh_flutter_x/main.dart';

enum AuthStatus { initial, authenticating, authenticated, unauthenticated, setupRequired }

class AuthState {
  final AuthStatus status;
  final Uint8List? masterKey;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.masterKey,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    Uint8List? masterKey,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      masterKey: masterKey ?? this.masterKey,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  AuthNotifier(this.ref) : super(AuthState(status: AuthStatus.initial)) {
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    final encryptionService = ref.read(encryptionServiceProvider);
    final isFirst = await encryptionService.isFirstLaunch();
    if (isFirst) {
      state = state.copyWith(status: AuthStatus.setupRequired);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    final encryptionService = ref.read(encryptionServiceProvider);

    final key = await encryptionService.verifyAndDeriveKey(password);
    if (key != null) {
      state = state.copyWith(status: AuthStatus.authenticated, masterKey: key);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: "Invalid master password");
    }
  }

  Future<void> setup(String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    final encryptionService = ref.read(encryptionServiceProvider);

    await encryptionService.setupMasterPassword(password);
    final key = await encryptionService.verifyAndDeriveKey(password);

    if (key != null) {
      state = state.copyWith(status: AuthStatus.authenticated, masterKey: key);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: "Setup failed");
    }
  }

  void logout() {
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));

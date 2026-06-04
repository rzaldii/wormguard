import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      final user = await _authService.login(username, password);

      if (user == null) {
        state = AsyncValue.error(
          'Username atau password salah',
          StackTrace.current,
        );
        return;
      }

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final currentUser = state.value;

    if (currentUser == null) {
      state = AsyncValue.error(
        'User belum login',
        StackTrace.current,
      );
      return;
    }

    try {
      final updatedUser = await _authService.updateUsername(
        currentUser: currentUser,
        newUsername: newUsername,
      );

      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
  }
}
class AuthService {
  Future<bool> login(String email, String password) async {
    // Dummy login: selalu berhasil jika email dan password tidak kosong
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
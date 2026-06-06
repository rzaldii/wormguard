import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String username, String password) async {
    final cleanUsername = username.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
      return null;
    }

    final query = await _firestore
        .collection('users')
        .where('username', isEqualTo: cleanUsername)
        .where('password', isEqualTo: cleanPassword)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final doc = query.docs.first;
    final data = doc.data();

    return UserModel.fromMap(data, doc.id);
  }

  Future<UserModel> updateUsername({
    required UserModel currentUser,
    required String newUsername,
  }) async {
    final cleanUsername = newUsername.trim();

    if (cleanUsername.isEmpty) {
      throw Exception('Username tidak boleh kosong');
    }

    if (cleanUsername == currentUser.username) {
      return currentUser;
    }

    final existingUser = await _firestore
        .collection('users')
        .where('username', isEqualTo: cleanUsername)
        .limit(1)
        .get();

    if (existingUser.docs.isNotEmpty) {
      throw Exception('Username sudah digunakan');
    }

    await _firestore.collection('users').doc(currentUser.uid).update({
      'username': cleanUsername,
    });

    return currentUser.copyWith(username: cleanUsername);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
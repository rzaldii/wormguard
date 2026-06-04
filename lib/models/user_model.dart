import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String password;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.password,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    final createdAtRaw = map['created_at'];

    DateTime? createdAt;

    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      createdAt = createdAtRaw;
    }

    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'created_at': createdAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? password,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
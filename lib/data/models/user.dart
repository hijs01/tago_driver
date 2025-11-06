import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.role = "driver",
  });

  // factory는 정적 영역이라 this 사용 불가 → map에서 바로 읽기
  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'driver',
    );
  }

  //  Firestore로 저장할 때 무조건 Map형태여야함 
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
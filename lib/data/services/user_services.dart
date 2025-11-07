import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tago_driver/data/models/user.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // drivers 컬렉션 (신규)
  CollectionReference<Map<String, dynamic>> get _driversCol =>
      _db.collection('drivers');

  // 기존 users 컬렉션 (마이그레이션 용도)
  CollectionReference<Map<String, dynamic>> get _legacyUsersCol =>
      _db.collection('users');

  // uid로 유저 정보 가지고 오기 (drivers 우선, 없으면 users에서 읽어와 저장)
  Future<AppUser?> getUser(String uid) async {
    // 1) drivers에서 우선 조회
    final driverDoc = await _driversCol.doc(uid).get();
    if (driverDoc.exists && driverDoc.data() != null) {
      return AppUser.fromMap(driverDoc.id, driverDoc.data()!);
    }

    // 2) 없으면 users(레거시)에서 조회 후 drivers로 승격 저장
    final legacyDoc = await _legacyUsersCol.doc(uid).get();
    if (legacyDoc.exists && legacyDoc.data() != null) {
      final user = AppUser.fromMap(legacyDoc.id, legacyDoc.data()!);
      await _driversCol.doc(uid).set(user.toMap(), SetOptions(merge: true));
      return user;
    }

    // 3) 둘 다 없으면 null
    return null;
  }

  // 유저 정보 저장/업데이트 (drivers에 기록)
  Future<void> saveUser(AppUser user) async {
    await _driversCol.doc(user.uid).set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }
}

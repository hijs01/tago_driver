import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tago_driver/data/models/user.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //users 컬렉션 레퍼런스

  CollectionReference<Map<String, dynamic>> get _usersCol =>
    _db.collection('users');

    // uid로 유저 정보 가지고 오기

    Future<AppUser?> getUser(String uid) async{
      final doc = await _usersCol.doc(uid).get();

      // 문서 없으면 Null로 리턴

      if(!doc.exists || doc.data() == null){
        return null;
      }

      //문서 잇으면 AppUser로 리턴
      return AppUser.fromMap(doc.id, doc.data()!);

    }


    //유저 정보 저장, 업데이트

    Future<void> saveUser(AppUser user) async{
      await _usersCol.doc(user.uid).set(
        user.toMap(),
        SetOptions(
          merge: true
        )
      );
    }

}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {
  User? _user;
  final _authentication = FirebaseAuth.instance;

  // user getter
  User? get user => _user;

  // userId getter 추가
  String? get userId => _user?.uid;

  // currentUser 메소드: 앱 시작 시 로그인 상태 확인
  void currentUser() {
    _user = _authentication.currentUser;
    notifyListeners();
  }

  // 로그인 기능
  Future<void> signIn(String email, String password) async {
    try {
      // 이전에 저장되어 있던 유저를 지움
      _user = null;
      // FirebaseAuth를 사용하여 이메일/비밀번호로 로그인 시도
      final credential = await _authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user; // 로그인 성공 시 유저 정보 설정
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // 로그인 실패 시 오류 메시지 처리 (예시)
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print('Error: ${e.message}');
      }
      rethrow; // 예외를 호출한 곳으로 다시 던짐 (UI에서 처리 가능)
    }
  }

  // 로그아웃 기능
  Future<void> signOut() async {
    await _authentication.signOut();
    _user = null; // 로그아웃 후 유저 정보 초기화
    notifyListeners();
  }

  // user
  User? loggedUser(BuildContext context) {
    final user = Provider.of<LoginProvider>(context).user;
    return user;
  }

  // final currentUser = Provider.of<LoginProvider>(context).user;
}

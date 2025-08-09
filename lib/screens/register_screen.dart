import 'dart:async';

import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:baettori/utils/style.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 회원가입 로딩창으로 이동

  // 회원가입 기능
  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    try {
      if (isValid) {
        showDialog(
          context: context,
          builder: (context) => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: mainBlue),
            ],
          ),
        );
        // Authentication에 계정 생성
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Cloud Firestore 초기화
        var db = FirebaseFirestore.instance;

        final user = <String, dynamic>{
          'name': _nameController.text,
          'email': _emailController.text,
          'uid': credential.user!.uid,
        };

        // db에 사용자 추가
        await db
            .collection('users')
            .doc(credential.user!.uid)
            .set(user)
            .onError((e, _) => print("Error :$e"));

        // 로그인
        await Provider.of<LoginProvider>(context, listen: false)
            .signIn(_emailController.text, _passwordController.text);

        // 메인 페이지로 이동

        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
        );
        // snackBarColor(context, '${_emailController.text} 님, 회원가입을 환영합니다!');
      }
    } catch (e) {
      snackBaError(context, '입력 값을 다시 확인해주세요.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        titleSpacing: 20,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        // 외부 영역 탭 시 키보드 닫기
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(bottom: 60),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'REGISTER',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 60),
                  fieldTitleStyle('Name'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    key: const ValueKey(1),
                    validator: (value) {
                      final regExp = RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{2,8}$');
                      if (value!.isEmpty) {
                        return '이름을 입력하세요.';
                      } else if (!regExp.hasMatch(value)) {
                        return '한글, 영문자, 숫자만 사용 가능합니다. (2~8자)';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {
                      // 한글 10글자 이상 금지
                      if (value.characters.length > 10) {
                        _nameController.text =
                            value.characters.take(10).toString();
                      }
                    },
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: registerFieldDecoration('이름'),
                  ),
                  const SizedBox(height: 20),
                  fieldTitleStyle('Email'),
                  const SizedBox(height: 10),
                  // 이메일 입력창
                  TextFormField(
                    controller: _emailController,
                    key: const ValueKey(2),
                    validator: (value) {
                      final regExp = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (value!.isEmpty) {
                        return '이메일을 입력하세요.';
                      } else if (!regExp.hasMatch(value)) {
                        return '올바른 이메일을 입력하세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: registerFieldDecoration('aaaaa@example.com'),
                  ),
                  const SizedBox(height: 20),
                  fieldTitleStyle('Password'),
                  const SizedBox(height: 10),
                  // 비밀번호 입력창
                  TextFormField(
                    controller: _passwordController,
                    key: const ValueKey(3),
                    validator: (value) {
                      final regExp = RegExp(
                          r'^((?=.*\d{1})(?=.*[a-zA-Z]{1}))+[a-zA-Z0-9]{8,20}$');
                      if (value!.isEmpty) {
                        return '비밀번호를 입력하세요.';
                      } else if (!regExp.hasMatch(value)) {
                        return '영문자, 숫자를 조합해 8~20자 이내로 입력하세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    obscureText: true,
                    enableInteractiveSelection: false,
                    textInputAction: TextInputAction.next,
                    decoration: registerFieldDecoration('영문자, 숫자 혼합 8자 이상'),
                  ),
                  const SizedBox(height: 10),
                  // 비밀번호 확인 입력창
                  TextFormField(
                    controller: _confirmPasswordController,
                    key: const ValueKey(4),
                    validator: (value) {
                      if (value!.isEmpty || value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    obscureText: true,
                    enableInteractiveSelection: false,
                    decoration: registerFieldDecoration('비밀번호 확인'),
                  ),
                  const SizedBox(height: 60),
                  // 회원가입 버튼
                  TextButton(
                    onPressed: () async {
                      _signUp();
                      // _goToLoading();
                    },
                    style:
                        TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: mainBlue,
                      ),
                      child: const Center(
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text fieldTitleStyle(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28));
  }
}

import 'package:baettori/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baettori/utils/style.dart';

import 'package:provider/provider.dart';
import 'package:baettori/providers/login_providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  bool _loginSuccess = true;

  // 로그인 기능
  Future<void> _login() async {
    _tryValidation();
    _loginSuccess = true;

    try {
      // 로딩창
      showDialog(
        context: context,
        builder: (context) => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: mainBlue),
          ],
        ),
      );
      await Provider.of<LoginProvider>(context, listen: false)
          .signIn(_emailController.text, _passwordController.text);

      //메인 스크린으로 이동
      Navigator.pushReplacementNamed(context, '/main');
      snackBarColor(context, '${_emailController.text} 님, 환영합니다!');
    } catch (e) {
      snackBaError(context, '이메일 또는 비밀번호를 잘못 입력했습니다.');
      Navigator.of(context).pop();
      _loginSuccess = false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // 이메일 입력창
                  TextFormField(
                    key: const ValueKey(1),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (_loginSuccess == false) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    enableInteractiveSelection: false,
                    decoration: loginFieldDecoration('이메일'),
                  ),
                  const SizedBox(height: 20),
                  // 비밀번호 입력창
                  TextFormField(
                    key: const ValueKey(2),
                    controller: _passwordController,
                    validator: (value) {
                      if (_loginSuccess == false) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    onFieldSubmitted: (value) {
                      _login();
                    },
                    obscureText: true,
                    enableInteractiveSelection: false,
                    decoration: loginFieldDecoration('비밀번호'),
                  ),
                  const SizedBox(height: 100),
                  // 로그인 버튼
                  TextButton(
                    onPressed: () {
                      _login();
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
                          '로그인',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '계정이 없으신가요?',
                        style: TextStyle(color: gray, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Create Account ',
                              style: TextStyle(color: mainBlue, fontSize: 16),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: mainBlue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

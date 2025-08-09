import 'package:baettori/screens/login_screen.dart';
import 'package:baettori/screens/main_screen.dart';
import 'package:baettori/screens/my_writing_screen.dart';
import 'package:baettori/screens/register_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> get routers {
  return {
    '/main': (context) => const MainScreen(),
    '/login': (context) => const LoginScreen(),
    '/signUp': (context) => const RegisterScreen(),
    '/write': (context) => const MyWritingScreen(),
  };
}

import 'package:baettori/router.dart';
import 'package:baettori/screens/login_screen.dart';
import 'package:baettori/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:baettori/providers/login_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: routers,
      title: '배또리',
      theme: themeData(),
      home: const LoginScreen(),

      // builder
      builder: (context, child) {
        return Center(
          child: ClipRect(
            child: SizedBox(
              width: 375,
              height: 812,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

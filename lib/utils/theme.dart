import 'package:baettori/utils/style.dart';
import 'package:flutter/material.dart';

ThemeData themeData() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: mainBlue,
    fontFamily: 'Pretendard',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // 탭바 설정
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: mainBlue,
      indicatorColor: mainBlue,
      unselectedLabelColor: gray,
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: mainBlue2,
      selectionHandleColor: mainBlue2,
      cursorColor: Colors.black87,
    ),
  );
}

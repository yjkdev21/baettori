import 'package:flutter/material.dart';

// 색상
const Color mainBlue = Color(0xFF3D54DF);
const Color mainBlue2 = Color(0xFF9FAAED);
const Color mainBlue1 = Color(0xFFF5F6FF);

const Color errColor = Color(0xFFF87A5E);

const Color darkGray = Color(0xff444444);
const Color gray = Color(0xff777777);
const Color lightGray = Color(0xffdddddd);

// 상단 네비게이션 탑바 고정 높이값
const Size topNavHeight = Size.fromHeight(60);

// 서브 텍스트 스타일
const TextStyle textStyleSub = TextStyle(color: gray, fontSize: 14);

// 디바이더
Widget listDivider(context, index) =>
    const Divider(height: 0, color: lightGray);

// 로그인 입력 폼
InputDecoration loginFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: gray),
    prefixIconConstraints: BoxConstraints.tight(const Size(20, 60)),
    prefixIcon: Container(width: 0),
    contentPadding: EdgeInsets.zero,
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: gray,
        width: 1,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: mainBlue2)),
    errorBorder:
        const OutlineInputBorder(borderSide: BorderSide(width: 1, color: gray)),
    errorStyle: const TextStyle(
      color: gray,
      fontSize: 0,
    ),
    focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: mainBlue2)),
  );
}

// 로그인 회원가입 입력 폼
InputDecoration registerFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: gray),
    prefixIconConstraints: BoxConstraints.tight(const Size(20, 60)),
    prefixIcon: Container(width: 0),
    contentPadding: EdgeInsets.zero,
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: gray,
        width: 1,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: mainBlue2)),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: errColor)),
    errorStyle: const TextStyle(
      color: errColor,
      fontSize: 14,
    ),
    focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: errColor)),
  );
}

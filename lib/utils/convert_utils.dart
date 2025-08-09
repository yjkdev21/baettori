import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 글 타입 표기 변환
postTypeConvert(bool type) {
  if (type == true) {
    return '소모임';
  } else {
    return '번개';
  }
}

// 모집 타입 표기 변환
postRecruitingConvert(bool recruiting) {
  if (recruiting == true) {
    return '모집중';
  } else {
    return '모집마감';
  }
}

// 글 작성시간 표기 변환 - 기본 (00/00/00 00:00)
postDateConvert(Timestamp time) {
  DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
      time.microsecondsSinceEpoch); // 글 작성 시간
  return DateFormat('yy/MM/dd HH:mm').format(dt);
}

// 글 작성시간 표기 변환 - 차이 (00분 전)
postDateDiffConvert(Timestamp time) {
  DateTime now = DateTime.now(); // 현재 시간
  DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
      time.microsecondsSinceEpoch); // 글 작성 시간

  final diffMin = now.difference(dt).inMinutes; // 분 차이
  final diffHour = now.difference(dt).inHours; // 시간 차이
  final diffDay = now.difference(dt).inDays; // 일자 차이

  if (diffMin < 60) {
    return '$diffMin분 전';
  } else if (diffMin > 59 && diffMin < 1440) {
    return '$diffHour시간 전';
  } else if (diffMin > 1439 && diffMin < 10080) {
    return '$diffDay일 전';
  } else if (diffMin > 10079 && (now.year == dt.year)) {
    return DateFormat('MM/dd').format(dt);
  } else {
    return DateFormat('yy/MM/dd').format(dt);
  }
}

// SVG 이미지 전환
svgIcon(String fileName) {
  return SvgPicture.asset('assets/icons/$fileName.svg');
}

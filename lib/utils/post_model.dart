// 포스트 모델
class PostModel {
  final bool type; // 글 타입 true: 소모임, false: 번개
  final bool recruiting; // 글 모집 상태 true: 모집중, false: 마감
  final String title; // 글 제목
  final String uid; // 글 작성자 uid
  final String content; // 글 내용
  final String place; // 모임 장소 설정
  final List<String> likes; // 좋아요 누른 횟수
  final int comments; // 지원 채팅의 수
  final DateTime time;

  PostModel({
    required this.type,
    required this.recruiting,
    required this.title,
    required this.uid,
    required this.content,
    required this.place,
    required this.likes,
    required this.comments,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'recruiting': recruiting,
      'title': title,
      'uid': uid,
      'content': content,
      'place': place,
      'likes': likes,
      'comments': comments,
      'time': time,
    };
  }
}

// 포스트 모델 - 글수정
class EditPostModel {
  final bool type; // 글 타입 true: 소모임, false: 번개
  final bool recruiting; // 글 모집 상태 true: 모집중으로 변경
  final String title; // 글 제목
  final String content; // 글 내용
  final String place; // 모임 장소 설정

  EditPostModel({
    required this.type,
    required this.recruiting,
    required this.title,
    required this.content,
    required this.place,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'recruiting': recruiting,
      'title': title,
      'content': content,
      'place': place,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 채팅방 개설
  Future<void> startChatting(String receiverId, String postId) async {
    // get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    // doc 이름 설정
    List ids = [
      postId,
      currentUserId.substring(0, 10),
      receiverId.substring(0, 10)
    ];
    ids.sort();
    final String chatRoomId = ids.join('_');

    // doc 내용 설정
    Map<String, String> users = {
      'postOwner': receiverId,
      'postVolunteer': currentUserId,
    };
    // chatRoomId 없으면 만들고(set) 있으면 업데이트
    final chatRoom =
        await _firestore.collection('chat_rooms').doc(chatRoomId).get();

    if (!chatRoom.exists) {
      await _firestore.collection('chat_rooms').doc(chatRoomId).set({
        'postId': postId,
        'users': users,
      });
    } else {
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'postId': postId,
        'users': users,
      });
    }
  }

  // SEND MESSAGE
  Future<void> sendMessage(
      String receiverId, String message, String postId) async {
    // get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: Timestamp.now(),
    );

    // doc 이름 설정
    List ids = [
      postId,
      currentUserId.substring(0, 10),
      receiverId.substring(0, 10)
    ];
    ids.sort();
    final String chatRoomId = ids.join('_');

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
    // 상위 doc 에도 시간 추가
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .update({'timestamp': Timestamp.now()});
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(
      String userId, String otherUserId, String postId) {
    // doc 이름 설정
    List ids = [postId, userId.substring(0, 10), otherUserId.substring(0, 10)];
    ids.sort();
    final String chatRoomId = ids.join('_');

    // construct chat room id from user ids
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

// Message Model
class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

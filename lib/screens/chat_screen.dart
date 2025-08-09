import 'package:baettori/utils/chat_service.dart';
import 'package:baettori/utils/convert_utils.dart';
import 'package:baettori/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final DocumentSnapshot postSnapshot;
  final Map<String, dynamic> receiverUser;
  const ChatScreen({
    super.key,
    required this.postSnapshot,
    required this.receiverUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DocumentSnapshot get postSnapshot => super.widget.postSnapshot;
  Map<String, dynamic> get receiverUser => super.widget.receiverUser;
  String get receiverUserId => super.widget.receiverUser['uid'];

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void setChatRoom() async {
    ChatService().startChatting(
      widget.receiverUser['uid'],
      postSnapshot.id,
    );
  }

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        receiverUserId,
        _messageController.text,
        postSnapshot.id,
      );
      // clear the text controller after sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    setChatRoom();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: topNavHeight,
        child: AppBar(
          title: Column(
            children: [
              Text(
                receiverUser['name'],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  '${postSnapshot['title']}',
                  style: const TextStyle(fontSize: 12, color: lightGray),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          backgroundColor: mainBlue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: svgIcon('ic_left-w'),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: GestureDetector(
        // 외부 영역 탭 시 키보드 닫기
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            // messages
            Expanded(
              child: _buildMessageList(),
            ),
            // user input
            __buildMessageInput(),
            const SizedBox(height: 34)
          ],
        ),
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return Container(
      color: mainBlue1,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder(
        stream: _chatService.getMessages(
          receiverUserId,
          _firebaseAuth.currentUser!.uid,
          postSnapshot.id,
        ),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: mainBlue));
          }

          var bubbles = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: bubbles.length,
            itemBuilder: (context, index) {
              final bubble = bubbles[index];

              // 채팅 버블 정렬
              var isSender =
                  (bubble['senderId'] == _firebaseAuth.currentUser!.uid);

              if (index == 0) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        '채팅방이 생성되었습니다.',
                        style: textStyleSub,
                      ),
                    ),
                    ChatBubble(isSender: isSender, bubble: bubble),
                  ],
                );
              }
              return ChatBubble(isSender: isSender, bubble: bubble);
            },
          );
        },
      ),
    );
  }

  // build message item
  Widget _buildMessageitem(document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if YOU send, else left otheruser send
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail']),
          Text(data['message']),
        ],
      ),
    );
  }

  // build message input

  Widget __buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // textfield
          Expanded(
            child: TextFormField(
              controller: _messageController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter Message',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // send button
          IconButton(onPressed: sendMessage, icon: svgIcon('ic_send')),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isSender,
    required this.bubble,
  });

  final bool isSender;
  final QueryDocumentSnapshot<Object?> bubble;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> setStyle = {
      'align': isSender ? Alignment.centerRight : Alignment.centerLeft,
      'bgcolor': isSender ? mainBlue : Colors.white,
      'color': isSender ? Colors.white : Colors.black,
      'crossAxis': isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: setStyle['align'],
      child: Column(
        children: [
          Column(
            crossAxisAlignment: setStyle['crossAxis'],
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: setStyle['bgcolor'],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: lightGray),
                ),
                child: SelectableText(
                  bubble['message'],
                  style: TextStyle(
                    fontSize: 16,
                    color: setStyle['color'],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // 시간 표기
              Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  DateFormat.Hm().format(bubble['timestamp'].toDate()),
                  style: const TextStyle(
                    color: gray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

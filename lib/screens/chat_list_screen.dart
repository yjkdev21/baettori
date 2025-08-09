import 'package:baettori/screens/chat_screen.dart';
import 'package:baettori/utils/convert_utils.dart';
import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth to get the current user

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: topNavHeight,
        child: TopBar(isProfile: false),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(top: 15, bottom: 13),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: mainBlue,
                    width: 2,
                  ),
                ),
              ),
              child: const Text(
                '내 채팅방',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 2,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildChaLIst(),
          ),
        ],
      ),
    );
  }

  // 채팅 목록을 Firestore에서 실시간으로 가져오기
  Widget _buildChaLIst() {
    final userId =
        FirebaseAuth.instance.currentUser?.uid ?? ''; // 현재 사용자 ID를 가져옴

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat_rooms') // Firestore에서 채팅 컬렉션 가져오기
          .orderBy('timestamp', descending: true) // 최신순 정렬
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 에러 발생 시
        if (snapshot.hasError) {
          return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
        }
        // 데이터가 없을 경우
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('채팅 목록이 없습니다.'));
        }
        final chats = snapshot.data!.docs;
        return ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: lightGray),
          itemBuilder: (context, index) {
            final chat = chats[index];

            final postId = chat['postId'];
            final chatUsers = chat['users'];
            final postOwnerId = chatUsers['postOwner'];
            final List chatUsersIds = [
              chatUsers['postOwner'],
              chatUsers['postVolunteer'],
            ];

            final bool isChatted = (chatUsersIds.contains(userId));

            List otherUserId = chatUsersIds;

            // 일부 추출
            if (isChatted) {
              otherUserId.remove(userId);
            } else {
              otherUserId = [];
            }

            return StreamBuilder(
              stream: _firestore.collection('posts').doc(postId).snapshots(),
              builder: (context, postSnapshot) {
                if (!postSnapshot.hasData) {
                  return Text('${postSnapshot.error}');
                }
                if (!isChatted) {
                  return const SizedBox.shrink();
                }
                final postData = postSnapshot.data!.data() ??
                    {'type': '', 'title': '삭제된 글입니다.'} as Map<String, dynamic>;

                return StreamBuilder(
                    stream: _firestore
                        .collection('users')
                        .doc(otherUserId[0])
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return Text('${postSnapshot.error}');
                      }
                      final otherUserData = userSnapshot.data?.data() ??
                          {'name': '(알수없음)'} as Map<String, dynamic>;
                      final bool isDeleted =
                          (otherUserData['name'] == '(알수없음)' ||
                              postData['title'] == '삭제된 글입니다.');
                      final DocumentSnapshot sendPostData = postSnapshot.data!;
                      // print('$index번째 $isChatted $otherUserId');
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        leading: const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/person_another.png'),
                          radius: 25,
                        ),
                        title: Row(
                          children: [
                            Container(
                              padding: !isDeleted
                                  ? const EdgeInsets.symmetric(horizontal: 6)
                                  : const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: !isDeleted
                                    ? Border.all(color: mainBlue)
                                    : null,
                                borderRadius: BorderRadius.circular(20),
                                color: (postOwnerId == userId)
                                    ? mainBlue
                                    : Colors.white,
                              ),
                              child: Text(
                                !isDeleted
                                    ? (postOwnerId == userId)
                                        ? '모집자'
                                        : '신청자'
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: (postOwnerId == userId)
                                      ? Colors.white
                                      : mainBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              !isDeleted
                                  ? (postData['type'] == true ||
                                          postData['type'] == false)
                                      ? '${postTypeConvert(postData['type'])} '
                                      : ''
                                  : '',
                              style: const TextStyle(color: mainBlue),
                            ),
                            Expanded(
                              child: Text(
                                '${postData['title']}', // Firestore 데이터에서 채팅 제목 가져오기
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        !isDeleted ? Colors.black : lightGray),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${otherUserData['name']} 님과의 대화',
                          // '${chat['']}', // Firestore에서 마지막 메시지 가져오기
                          style: textStyleSub,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // DateFormat.Hm().format(chat['timestamp'].toDate())
                              postDateDiffConvert(chat['timestamp']),
                              style: const TextStyle(
                                fontSize: 12,
                                color: gray,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        onTap: !isDeleted
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      postSnapshot: sendPostData,
                                      receiverUser: otherUserData,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      );
                    });
              },
            );
          },
        );
      },
    );
  }
}

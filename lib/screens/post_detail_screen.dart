import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/screens/chat_screen.dart';
import 'package:baettori/screens/my_editing_screen.dart';
import 'package:baettori/utils/style.dart';
import 'package:baettori/utils/convert_utils.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  final int postIndex;
  const PostDetailScreen(this.postIndex, {super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // Firestore 에서 게시글 DB 불러오기
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final User? loggedUser = Provider.of<LoginProvider>(context).user;
    final int index = widget.postIndex;
    return StreamBuilder<QuerySnapshot>(
      stream:
          _db.collection('posts').orderBy('time', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (!streamSnapshot.hasData) {
          return const Scaffold(body: Center());
        }
        final DocumentSnapshot postSnapshot = streamSnapshot.data!.docs[index];
        final Stream<DocumentSnapshot> writterSnapshot =
            _db.collection('users').doc(postSnapshot['uid']).snapshots();
        return StreamBuilder(
          stream: writterSnapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            Object? getWritter = snapshot.data?.data() ?? {'uid': ''};
            final writterData = getWritter as Map<String, dynamic>;

            // 로그인 유저가 작성자인지 확인
            final bool isWrote = loggedUser?.uid == writterData['uid'];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: topNavHeight,
                child: PostDetailTopBar(
                  isWrote: isWrote,
                  postSnapshot: postSnapshot,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: mainBlue,
                              border: Border.all(width: 1, color: mainBlue),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              postTypeConvert(postSnapshot['type']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              postRecruitingConvert(postSnapshot['recruiting']),
                              style: TextStyle(
                                color: (postSnapshot['recruiting'])
                                    ? mainBlue
                                    : gray,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${postSnapshot['title']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: (isWrote)
                                    ? const AssetImage(
                                        'assets/images/person.png')
                                    : const AssetImage(
                                        'assets/images/person_another.png'),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${writterData['name']}'),
                                  Text(
                                    postDateConvert(postSnapshot['time']),
                                    style: textStyleSub,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/ic_heart-g.svg',
                                      width: 18),
                                  const SizedBox(width: 4),
                                  Text(postSnapshot['likes'].length.toString(),
                                      style: textStyleSub),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/ic_chat-g.svg',
                                      width: 18),
                                  const SizedBox(width: 4),
                                  Text(postSnapshot['comments'].toString(),
                                      style: textStyleSub),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Divider(color: lightGray, thickness: 1, height: 20),
                      const SizedBox(height: 16),
                      SelectableText(
                        '${postSnapshot['content']}\n',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/ic_place-g.svg',
                              width: 18),
                          const SizedBox(width: 8),
                          Text(
                            postSnapshot['place'],
                            style: const TextStyle(color: gray, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: PostDetailBottomBar(
                isWrote: isWrote,
                postSnapshot: postSnapshot,
                postId: postSnapshot.id,
                userUid: loggedUser!.uid,
                likes: List<String>.from(postSnapshot['likes'] ?? []),
                writterData: writterData,
              ),
            );
          },
        );
      },
    );
  }
}

// 상단바
// PostDetailTopBar
class PostDetailTopBar extends StatefulWidget {
  const PostDetailTopBar({
    super.key,
    required this.isWrote,
    required this.postSnapshot,
  });

  final bool isWrote;
  final DocumentSnapshot postSnapshot;

  @override
  State<PostDetailTopBar> createState() => _PostDetailTopBarState();
}

class _PostDetailTopBarState extends State<PostDetailTopBar> {
  final CollectionReference postRef =
      FirebaseFirestore.instance.collection('posts');
  // 게시글 삭제
  Future<void> _postDelete() async {
    try {
      // 메인 이동
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false,
      );
      await postRef.doc(widget.postSnapshot.id).delete();
    } catch (e) {
      snackBaError(context, 'Error : $e');
    }
  }

  // 모집 상태 변경
  Future<void> _toggleRecruiting() async {
    bool isRecruited = widget.postSnapshot['recruiting'];
    try {
      // print(isRecruited);
      await postRef
          .doc(widget.postSnapshot.id)
          .update({'recruiting': !isRecruited});
      Navigator.pop(context);
      snackBarNormal(context, '모집 상태가 변경되었습니다.');
    } catch (e) {
      snackBaError(context, 'Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainBlue,
      titleSpacing: 20,
      elevation: 0,
      leading: IconButton(
        icon: svgIcon('ic_left-w'),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('게시글',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      actions: [
        (widget.isWrote)
            ? IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 40,
                        ),
                        color: mainBlue1,
                        child: Wrap(
                          children: [
                            ListTile(
                              title: Text(
                                (widget.postSnapshot['recruiting'])
                                    ? '모집마감'
                                    : '모집중',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                // 모집 상태 변경하는 코드 추가 필요
                                _toggleRecruiting();
                              },
                            ),
                            ListTile(
                              title: const Text(
                                '수정하기',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyEditingScreen(
                                        postSnapshot: widget.postSnapshot),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                '삭제',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                _postDelete();
                                snackBarNormal(context, '정상적으로 삭제되었습니다.');
                              },
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : const SizedBox(),
      ],
    );
  }
}

// 하단바
class PostDetailBottomBar extends StatefulWidget {
  const PostDetailBottomBar({
    super.key,
    required this.isWrote,
    required this.postSnapshot,
    required this.postId,
    required this.userUid,
    required this.likes,
    required this.writterData,
  });

  final bool isWrote;
  final DocumentSnapshot postSnapshot;
  final String postId;
  final String userUid;
  final List<String> likes;
  final Map<String, dynamic> writterData;

  @override
  _PostDetailBottomBarState createState() => _PostDetailBottomBarState();
}

class _PostDetailBottomBarState extends State<PostDetailBottomBar> {
  // get 가져오기
  bool get isWrote => super.widget.isWrote;
  DocumentSnapshot get postSnapshot => super.widget.postSnapshot;
  String get postId => super.widget.postId;
  String get userUid => super.widget.userUid;
  List<String> get likes => super.widget.likes;

  bool _isLiked = false;
  @override
  void initState() {
    super.initState();
    _isLiked = likes.contains(userUid);
  }

  Future<void> _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    if (_isLiked) {
      // 좋아요 리스트에 유저id 증가
      await postRef.update({
        'likes': FieldValue.arrayUnion([userUid])
      });
    } else {
      // 좋아요 리스트에 유저id 삭제
      await postRef.update({
        'likes': FieldValue.arrayRemove([userUid])
      });
    }
    snackBarNormal(context, _isLiked ? '관심 목록에 추가되었습니다.' : '관심 목록에서 삭제되었습니다.');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 관심글 버튼
            Stack(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(bottom: 4),
                  icon: isWrote
                      ? SvgPicture.asset('assets/icons/ic_heart-lg.svg')
                      : _isLiked
                          ? SvgPicture.asset('assets/icons/ic_heart-fill.svg')
                          : SvgPicture.asset('assets/icons/ic_heart-g.svg'),
                  iconSize: 24,
                  onPressed: !isWrote
                      ? () {
                          _toggleLike();
                        }
                      : null,
                ),
                Positioned(
                  width: 20,
                  bottom: -2,
                  left: 14,
                  child: Text(
                    likes.length.toString(),
                    style: const TextStyle(
                      color: gray,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // 채팅방 버튼
            ElevatedButton(
              onPressed: (postSnapshot['recruiting'])
                  ? !isWrote
                      ? (!(widget.writterData['name'] == '(알수없음)'))
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    postSnapshot: postSnapshot,
                                    receiverUser: widget.writterData,
                                  ),
                                ),
                              );
                            }
                          : null
                      : null
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // minimumSize: const Size(300, 60),
                  fixedSize: Size(
                      (MediaQuery.of(context).size.width - (40 + 48 + 20)),
                      80)),
              child: Text(
                (postSnapshot['recruiting'])
                    ? !isWrote
                        ? '모임 신청'
                        : '모집 중'
                    : '모집 완료',
                // '${context.widget}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: (postSnapshot['recruiting'])
                      ? !isWrote
                          ? Colors.white
                          : gray
                      : gray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

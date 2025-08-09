import 'package:baettori/screens/post_detail_screen.dart';
import 'package:baettori/utils/convert_utils.dart';
import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 게시글 리스트

final List<String> _styles = ['', '관심 목록', '작성 내역', '신청 내역'];

class PostView extends StatelessWidget {
  const PostView({
    super.key,
    required this.postLength,
    required this.getSnapshot,
    required this.isHomed,
    required this.tabType,
  });

  final int postLength;
  final AsyncSnapshot<QuerySnapshot> getSnapshot;
  final bool isHomed;
  final String tabType;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: postLength,
      separatorBuilder: listDivider,
      itemBuilder: (context, index) {
        final DocumentSnapshot postSnapshot = getSnapshot.data!.docs[index];
        final tabTile = EachListTile(
            postSnapshot: postSnapshot,
            index: index,
            style: _styles[0],
            userId: '');
        // '전체', '소모임', '번개'
        switch (tabType) {
          case '전체':
            return tabTile;
          case '소모임':
            if (postSnapshot['type'] == true) {
              return tabTile;
            }
            return const SizedBox.shrink();
          case '번개':
            if (postSnapshot['type'] == false) {
              return tabTile;
            }
            return const SizedBox.shrink();
          default:
            return tabTile;
        }
      },
      physics: (isHomed) ? const NeverScrollableScrollPhysics() : null,
    );
  }
}

// 마이페이지 게시글 리스트
class MyPostView extends StatelessWidget {
  const MyPostView({
    super.key,
    required this.postLength,
    required this.getSnapshot,
    required this.userId,
    required this.menuType,
  });

  final int postLength;
  final AsyncSnapshot<QuerySnapshot> getSnapshot;
  final String userId;

  final String menuType;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: postLength,
      separatorBuilder: listDivider,
      itemBuilder: (context, index) {
        final DocumentSnapshot postSnapshot = getSnapshot.data!.docs[index];
        // '관심 목록', '작성 내역', '신청 내역'
        switch (menuType) {
          // 관심 목록
          case '관심 목록':
            final isFavorite = postSnapshot['likes'].contains(userId);
            if (!isFavorite) {
              return const SizedBox.shrink();
            }
            return EachListTile(
              postSnapshot: postSnapshot,
              index: index,
              userId: userId,
              style: _styles[1],
            );
          case '작성 내역':
            final bool isWrote = (userId == postSnapshot['uid']);
            if (!isWrote) {
              return const SizedBox.shrink();
            }
            return EachListTile(
              postSnapshot: postSnapshot,
              index: index,
              userId: userId,
              style: _styles[2],
            );

          case '신청 내역':
            return EachListTile(
              postSnapshot: postSnapshot,
              index: index,
              userId: userId,
              style: _styles[3],
            );

          default:
            return null;
        }
      },
    );
  }
}

class EachListTile extends StatelessWidget {
  const EachListTile({
    super.key,
    required this.postSnapshot,
    required this.index,
    required this.style,
    required this.userId,
  });

  final DocumentSnapshot<Object?> postSnapshot;
  final int index;
  final String userId;
  final String style;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      title: Row(
        children: [
          Text(
            postTypeConvert(postSnapshot['type']),
            style: const TextStyle(
              color: mainBlue,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            (!postSnapshot['recruiting'])
                ? '[${postRecruitingConvert(postSnapshot['recruiting'])}]'
                : '',
            style: const TextStyle(color: gray, fontSize: 18),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              postSnapshot['title'],
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/ic_heart-g.svg', width: 18),
                const SizedBox(width: 4),
                Text(postSnapshot['likes'].length.toString(),
                    style: textStyleSub),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                SvgPicture.asset('assets/icons/ic_chat-g.svg', width: 18),
                const SizedBox(width: 4),
                Text(postSnapshot['comments'].toString(), style: textStyleSub),
              ],
            ),
            const SizedBox(width: 5),
            const Text('|', style: TextStyle(color: lightGray)),
            const SizedBox(width: 5),
            Text(postDateDiffConvert(postSnapshot['time']),
                style: textStyleSub),
          ],
        ),
      ),
      trailing: rightBtnHandle(style),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(index),
          ),
        );
      },
    );
  }

  Widget rightBtnHandle(String style) {
    if (style == _styles[1]) {
      return DeleteLikeBtn(postSnapshot: postSnapshot, userId: userId);
    }
    return const SizedBox.shrink();
  }
}

// 관심 목록 - 삭제 버튼
class DeleteLikeBtn extends StatefulWidget {
  const DeleteLikeBtn({
    super.key,
    required this.postSnapshot,
    required this.userId,
  });

  final DocumentSnapshot<Object?> postSnapshot;
  final String userId;

  @override
  State<DeleteLikeBtn> createState() => _DeleteLikeBtnState();
}

class _DeleteLikeBtnState extends State<DeleteLikeBtn> {
  Future<void> _deleteLike() async {
    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postSnapshot.id);

    try {
      // 좋아요 리스트에 유저id 삭제
      await postRef.update({
        'likes': FieldValue.arrayRemove([widget.userId])
      });
    } catch (e) {
      snackBaError(context, '에러 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: svgIcon('ic_heart-fill'),
      onPressed: () {
        _deleteLike();
        snackBarNormal(context, '관심 목록에서 삭제되었습니다.');
      },
    );
  }
}

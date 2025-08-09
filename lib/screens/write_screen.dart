import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/widgets/post_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteScreen extends StatelessWidget {
  WriteScreen({super.key});

  // Firestore 에서 게시글 DB 불러오기
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // user
    final currentUser = Provider.of<LoginProvider>(context).user;
    final userId = currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '작성 내역',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // 바디
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _db
              .collection('posts')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!streamSnapshot.hasData) {
              return const Center(child: Text('데이터가 없습니다.'));
            }
            final posts = streamSnapshot.data!.docs;
            return MyPostView(
              postLength: posts.length,
              getSnapshot: streamSnapshot,
              userId: userId,
              menuType: '작성 내역',
            );
          },
        ),
      ),
    );
  }
}

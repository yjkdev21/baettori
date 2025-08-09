import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/widgets/post_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // current user
    final currentUser = Provider.of<LoginProvider>(context).user;
    final userId = currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '신청 내역',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
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
              menuType: '신청 내역',
            );
          },
        ),
      ),
    );
  }
}

import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/post_view.dart';
import 'package:baettori/widgets/top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with TickerProviderStateMixin {
  late TabController _tab;

  // Firestore 에서 게시글 DB 불러오기
  final CollectionReference _postRef =
      FirebaseFirestore.instance.collection('posts');

  // 탭들
  final List<Widget> _tabs = [
    const Tab(text: '전체'),
    const Tab(text: '소모임'),
    const Tab(text: '번개'),
  ];

  // get
  List<Widget> get tabs => _tabs;
  TabController get tabController => _tab;

  @override
  void initState() {
    super.initState();
    //탭 컨트롤러 초기화
    _tab = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
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
          children: [
            postTabBar(),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  postStreamBuilder('전체'),
                  postStreamBuilder('소모임'),
                  postStreamBuilder('번개'),
                ],
              ),
            ),
          ],
        ));
  }

  Widget postStreamBuilder(tabType) {
    Stream<QuerySnapshot<Object?>> newQuery =
        _postRef.orderBy('time', descending: true).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: newQuery,
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (!streamSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        int postLength = streamSnapshot.data!.docs.length;

        final AsyncSnapshot<QuerySnapshot> getSnapshot = streamSnapshot;
        return PostView(
          postLength: postLength,
          getSnapshot: getSnapshot,
          isHomed: false,
          tabType: tabType,
        );
      },
    );
  }

  // 탭 바
  TabBar postTabBar() {
    return TabBar(
      controller: tabController,
      tabs: _tabs,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Colors.white,
      padding: const EdgeInsets.only(left: 10),
      labelPadding: const EdgeInsets.only(top: 12, left: 10, right: 10),
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}

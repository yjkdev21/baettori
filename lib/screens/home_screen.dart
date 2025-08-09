// file: lib/screen/home_screen.dart

import 'package:baettori/screens/post_screen.dart';
import 'package:baettori/widgets/post_view.dart';
import 'package:baettori/widgets/top_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:baettori/utils/style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Firestore 에서 게시글 DB 불러오기
  final CollectionReference _postRef =
      FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단 메뉴바
      appBar: const PreferredSize(
        preferredSize: topNavHeight,
        child: TopBar(isProfile: false),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 메인 홈 배너
              BannerSlider(postRef: _postRef),
              // 홈 컨텐츠
              Column(
                children: [
                  // 최신글 목록
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '최신 글',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _postRef.orderBy('time', descending: true).get(),
                    builder: (context, furtureSnapshot) {
                      if (!furtureSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      int postLength = (furtureSnapshot.data!.docs.length < 3)
                          ? furtureSnapshot.data!.docs.length
                          : 3;
                      return PostView(
                        postLength: postLength,
                        getSnapshot: furtureSnapshot,
                        isHomed: true,
                        tabType: '',
                      );
                    },
                  ),

                  // ////Test
                  const SizedBox(height: 60),
                  // 인기글 목록 => 추후 정령방식 수정
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '인기 글',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _postRef.orderBy('likes', descending: true).get(),
                    builder: (context, furtureSnapshot) {
                      if (!furtureSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      int postLength = (furtureSnapshot.data!.docs.length < 3)
                          ? furtureSnapshot.data!.docs.length
                          : 3;
                      return PostView(
                        postLength: postLength,
                        getSnapshot: furtureSnapshot,
                        isHomed: true,
                        tabType: '인기글',
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 메인 배너 슬라이더 위젯
class BannerSlider extends StatelessWidget {
  const BannerSlider({
    super.key,
    required CollectionReference<Object?> postRef,
  }) : _postRef = postRef;

  final CollectionReference<Object?> _postRef;

  @override
  Widget build(BuildContext context) {
    final bannerList = [mainBanner(context, false), mainBanner(context, true)];

    return CarouselSlider(
        items: bannerList,
        options: CarouselOptions(
          viewportFraction: 1,
          height: 620,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
        ));
  }

  Widget mainBanner(BuildContext context, bool isSomoim) {
    return Column(
      children: [
        Stack(
          children: [
            // 메인 배너 텍스트
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: '이런 '),
                        TextSpan(
                          text: (isSomoim) ? '소모임' : '번개',
                          style: const TextStyle(color: mainBlue),
                        ),
                        TextSpan(text: (isSomoim) ? '은' : '는'),
                        const TextSpan(text: '\n어때요?'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (isSomoim) ? '우리 함께해요!' : '혹시, 번개세요?',
                    style: const TextStyle(
                      color: darkGray,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            // 배너 이미지
            Container(
              padding: (isSomoim)
                  ? const EdgeInsets.only(left: 120, top: 125)
                  : const EdgeInsets.only(left: 78, top: 125),
              child: Image.asset(
                (isSomoim)
                    ? 'assets/images/banner_group.png'
                    : 'assets/images/banner_volt.png',
                width: double.infinity,
                height: 180,
              ),
            ),
            // 배너 3개 게시글
            Padding(
              padding: const EdgeInsets.only(top: 280),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: mainBlue,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FutureBuilder(
                        future: (isSomoim)
                            ? _postRef.orderBy('type', descending: true).get()
                            : _postRef.orderBy('type', descending: false).get(),
                        builder: (context, furtureSnapshot) {
                          if (!furtureSnapshot.hasData) {
                            return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 90),
                                child:
                                    CircularProgressIndicator(color: mainBlue));
                          }
                          int postLength =
                              (furtureSnapshot.data!.docs.length < 3)
                                  ? furtureSnapshot.data!.docs.length
                                  : 3;
                          return PostView(
                            postLength: postLength,
                            getSnapshot: furtureSnapshot,
                            isHomed: true,
                            tabType: (isSomoim) ? '소모임' : '번개',
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      decoration: const BoxDecoration(
                        color: mainBlue,
                      ),
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (isSomoim)
                                  ? '더 많은 소모임 글 보러 가기'
                                  : '더 많은 번개 글 보러 가기',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset(
                              'assets/icons/ic_right-w.svg',
                              width: 14,
                            ),
                          ],
                        ),
                        onPressed: () {
                          // 포스트화면으로 이동
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PostScreen(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 0),
      ],
    );
  }
}

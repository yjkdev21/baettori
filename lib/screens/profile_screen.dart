import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/utils/convert_utils.dart';
import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:baettori/widgets/top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_edit_screen.dart'; // 프로필 수정
import 'favorites_screen.dart'; // 관심 목록
import 'write_screen.dart'; // 작성 내역
import 'history_screen.dart'; // 신청 내역

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final _userRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginProvider>(context).user;
    final Stream<DocumentSnapshot<Object?>> userSnapshot =
        _userRef.doc(currentUser?.uid).snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: topNavHeight,
        child: TopBar(isProfile: true),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: lightGray)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/person.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: StreamBuilder(
                              stream: userSnapshot,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final Map<String, dynamic> userData;
                                  if (snapshot.data!.data() != null) {
                                    userData = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                  } else {
                                    userData = {'name': ''};
                                  }
                                  return Text(
                                    userData['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                return Text(
                                  '${currentUser?.email}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileEditScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              decoration: const BoxDecoration(
                                  color: mainBlue1,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: const Text(
                                "프로필 편집",
                                style: TextStyle(color: mainBlue, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '나의 활동',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          leading: svgIcon('ic_heart'),
          title: const Text(
            '관심 목록',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 5,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          },
        ),
        ListTile(
          leading: svgIcon('ic_pen'),
          title: const Text(
            '작성 내역',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 5,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WriteScreen()),
            );
          },
        ),
        ListTile(
          leading: svgIcon('ic_letter'),
          title: const Text(
            '신청 내역',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 5,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          },
        ),
        const Divider(color: lightGray, thickness: 1),
        ListTile(
          title: const Text(
            '자주 묻는 질문',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.zero,
          onTap: () {
            snackBarColor(context, '추후 업데이트를 기대해주세요!');
          },
        ),
        ListTile(
          title: const Text(
            '약관 및 정책',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.zero,
          onTap: () {
            snackBarColor(context, '추후 업데이트를 기대해주세요!');
          },
        ),
        ListTile(
          title: const Text(
            '로그아웃',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.zero,
          onTap: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '아니오',
                style: TextStyle(color: mainBlue),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Provider.of<LoginProvider>(context, listen: false).signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              isDestructiveAction: true,
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }
}

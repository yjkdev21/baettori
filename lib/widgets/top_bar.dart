import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/screens/main_screen.dart';
import 'package:baettori/utils/convert_utils.dart';
import 'package:flutter/material.dart';
import 'package:baettori/screens/search_screen.dart';
import 'package:baettori/screens/notification_screen.dart';
import 'package:baettori/utils/style.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.isProfile,
  });

  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainBlue,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 20,
      title: IconButton(
        padding: EdgeInsets.zero,
        icon: Image.asset(
          'assets/images/logo-w.png',
          height: 28,
        ),
        onPressed: () {
          Navigator.canPop(context);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation animation1,
                  Animation animation2) {
                return const MainScreen();
              },
            ),
          );
          // Navigator.pushReplacementNamed(context, '/main');
        },
      ),
      actions:
          //
          (isProfile)
              ? <Widget>[
                  PopupMenuButton<String>(
                    icon: svgIcon('ic_menu-w'),
                    onSelected: (String result) {
                      switch (result) {
                        case 'logout':
                          // 로그아웃 동작
                          break;
                        case 'help':
                          // 도움말 동작
                          break;
                      }
                    },
                    color: mainBlue1,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: const Text('로그아웃'),
                        onTap: () {
                          Provider.of<LoginProvider>(context, listen: false)
                              .signOut();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 10)
                ]
              : <Widget>[
                  IconButton(
                    icon: svgIcon('ic_search-w'),
                    iconSize: 24,
                    onPressed: () {
                      // 검색 버튼 클릭 시 SearchScreen으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: svgIcon('ic_noti-w'),
                    iconSize: 24,
                    onPressed: () {
                      // 알림 버튼 클릭 시 기능 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
      //
    );
  }
}

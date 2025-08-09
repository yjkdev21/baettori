import 'package:baettori/screens/chat_list_screen.dart';
import 'package:baettori/screens/home_screen.dart';
import 'package:baettori/screens/post_screen.dart';
import 'package:baettori/screens/profile_screen.dart';
import 'package:baettori/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // 홈 탭
        break;
      case 1: // 게시글 탭
        break;
      case 2: // 작성 탭
        Navigator.pushNamed(context, '/write');
        break;
      case 3: // 채팅 탭
        break;
      case 4: // 프로필 탭
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MainIndexedStack(selectedIndex: _selectedIndex),
      // 하단 메뉴바
      bottomNavigationBar: Stack(children: [bottomNavBar()]),
    );
  }

  Container bottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: lightGray, width: 1))),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'home',
            activeIcon: SvgPicture.asset('assets/icons/ic_home-fill.svg'),
            icon: SvgPicture.asset('assets/icons/ic_home-b2.svg'),
          ),
          BottomNavigationBarItem(
            label: 'article',
            activeIcon: SvgPicture.asset('assets/icons/ic_article-fill.svg'),
            icon: SvgPicture.asset('assets/icons/ic_article-b2.svg'),
          ),
          BottomNavigationBarItem(
            label: 'write',
            icon: SvgPicture.asset('assets/icons/ic_add-b2.svg'),
          ),
          BottomNavigationBarItem(
            label: 'chat',
            activeIcon: SvgPicture.asset('assets/icons/ic_chat-fill.svg'),
            icon: SvgPicture.asset('assets/icons/ic_chat-b2.svg'),
          ),
          BottomNavigationBarItem(
            label: 'profile',
            activeIcon: SvgPicture.asset('assets/icons/ic_profile-fill.svg'),
            icon: SvgPicture.asset('assets/icons/ic_profile-b2.svg'),
          ),
        ],
      ),
    );
  }
}

class MainIndexedStack extends StatelessWidget {
  const MainIndexedStack({
    super.key,
    required int selectedIndex,
  }) : _selectedIndex = selectedIndex;

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: const <Widget>[
        HomeScreen(),
        PostScreen(),
        Center(),
        ChatListScreen(),
        ProfileSection(),
      ],
    );
  }
}

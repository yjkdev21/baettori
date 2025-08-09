import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // (임의)Firebase 알림 데이터를 가져오기
  Future<List<String>> _fetchNotifications() async {
    return List.generate(10, (index) => '알림 내용 ${index + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: topNavHeight,
        child: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '알림',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('알림을 불러오는 중 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('새로운 알림이 없습니다.'));
          } else {
            final notifications = snapshot.data!;
            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 0.5, color: Color(0xFFDDDDDD)),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('알림 세부사항 ${index + 1}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // 알림 클릭 시 동작
                    snackBarColor(context, '추후 업데이트를 기대해주세요!');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

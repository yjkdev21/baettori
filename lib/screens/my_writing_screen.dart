import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/screens/main_screen.dart';
import 'package:baettori/utils/my_post_utils.dart';
import 'package:baettori/utils/post_model.dart';
import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyWritingScreen extends StatefulWidget {
  const MyWritingScreen({super.key});

  @override
  _MyWritingScreenState createState() => _MyWritingScreenState();
}

class _MyWritingScreenState extends State<MyWritingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = '소모임'; // 소모임/번개 선택을 위한 변수
  bool _typeController = true; // true: 소모임, false: 번개
  bool _isOnline = false; // 온라인 여부를 위한 변수
  Color checkColor = gray;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // 공백(false)일 경우 등록버튼 비활성화
  bool _isValid() {
    return _titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _locationController.text.isNotEmpty;
  }

  // Firestore에 게시글 추가
  Future<void> _postSuccess(user) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      try {
        final db = FirebaseFirestore.instance;

        // 글 추가
        final newPost = PostModel(
          type: _typeController,
          recruiting: true,
          title: _titleController.text,
          uid: user?.uid,
          content: _contentController.text,
          place: _locationController.text,
          likes: [],
          comments: 0,
          time: DateTime.now(),
        );

        // 등록되는 문서명을 별도로 지정(날짜+타입+타입의갯수)
        await db
            .collection('posts')
            .where('type', isEqualTo: newPost.type)
            .count()
            .get()
            .then((value) {
          String documentName = (newPost.type)
              ? '${DateFormat('yyMMddHHmm').format(newPost.time)}S${value.count}'
              : '${DateFormat('yyMMddHHmm').format(newPost.time)}B${value.count}';

          // 게시글 등록
          db.collection('posts').doc(documentName).set(newPost.toMap());
          // 메인으로 이동
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
          // Navigator.pushReplacementNamed(context, '/main');
        });
      } catch (e) {
        snackBaError(context, '글 등록 중 오류가 발생했습니다. 다시 시도해주세요.');
      }
      snackBarNormal(context, '게시글이 등록되었습니다.');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // user
    final currentUser = Provider.of<LoginProvider>(context).user;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation animation1,
                      Animation animation2) {
                    return const MainScreen();
                  },
                ),
              );
            },
          ),
          actions: [
            SizedBox(
              width: 80,
              height: 35,
              child: ElevatedButton(
                onPressed: _isValid()
                    ? () {
                        _postSuccess(currentUser);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 25,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타입 선택버튼
                  DropdownButton<String>(
                    key: const ValueKey(1),
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                        _typeController = _selectedCategory == '소모임';
                      });
                    },
                    items: <String>['소모임', '번개']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 18,
                            color: mainBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.white,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // 제목 입력창
                  TextFormField(
                    controller: _titleController,
                    key: const ValueKey(2),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      // 비어있거나 띄어쓰기만 넣었을 경우
                      return checkValue(value);
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: writeInputDecoration('제목을 입력하세요'),
                  ),
                  const SizedBox(height: 20),
                  // 내용 입력창
                  TextFormField(
                    controller: _contentController,
                    key: const ValueKey(3),
                    validator: (value) {
                      // 비어있거나 띄어쓰기만 넣었을 경우
                      return checkValue(value);
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    minLines: 10,
                    maxLines: null,
                    style: const TextStyle(fontSize: 18),
                    decoration: writeInputDecoration('내용을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  // 위치 입력창
                  const Text(
                    '위치',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _locationController,
                          key: const ValueKey(4),
                          enabled: !_isOnline,
                          validator: (value) {
                            // 비어있거나 띄어쓰기만 넣었을 경우
                            return checkValue(value);
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: const TextStyle(fontSize: 18),
                          decoration: writeInputDecoration('위치를 입력하세요'),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: ListTileTheme(
                          horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.zero,
                          child: CheckboxListTile(
                            title: Text(
                              '온라인',
                              style: TextStyle(color: checkColor),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: mainBlue,
                            value: _isOnline,
                            onChanged: (value) {
                              setState(() {
                                _isOnline = value ?? false;
                                _locationController.text =
                                    _isOnline ? '온라인' : '';
                                checkColor = _isOnline ? mainBlue : gray;
                              });
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

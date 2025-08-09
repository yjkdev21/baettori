import 'package:baettori/providers/login_providers.dart';
import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _userRef = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _editNameController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  // 프로필 수정
  Future<void> _editField(currentUser) async {
    String newValue = _editNameController.text;
    final isValid = _formKey.currentState!.validate();
    try {
      if (isValid) {
        _formKey.currentState!.save();

        _userRef.doc(currentUser?.uid).update({'name': newValue});

        snackBarNormal(context, '변경 사항이 저장되었습니다.');
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      }
    } catch (e) {
      print('catch => $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _editNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // user
    final currentUser = Provider.of<LoginProvider>(context).user;
    final Stream<DocumentSnapshot<Object?>> userSnapshot =
        _userRef.doc(currentUser?.uid).snapshots();

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        body: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/ic_close-b.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            title: const Text(
              '프로필 편집',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        const Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/person.png'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('이름'),
                        ),
                        //이름 수정
                        Container(
                          child: StreamBuilder(
                            stream: userSnapshot,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('${snapshot.error}');
                              }
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return TextFormField(
                                controller: _editNameController,
                                focusNode: _focusNode,
                                validator: (value) {
                                  final regExp =
                                      RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{2,8}$');
                                  if (value == null || value.isEmpty) {
                                    return '이름을 입력해 주세요.';
                                  }
                                  if (!regExp.hasMatch(value)) {
                                    return '한글, 영문자, 숫자만 사용 가능합니다. (2~8자)';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                                onSaved: (value) {},
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  labelStyle: const TextStyle(color: mainBlue),
                                  hintText: userData['name'],
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: mainBlue)),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: lightGray)),
                                  errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: errColor)),
                                  focusedErrorBorder:
                                      const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: errColor)),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            height: 92,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: mainBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: const Text(
                      '변경 사항 저장',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _editField(currentUser);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

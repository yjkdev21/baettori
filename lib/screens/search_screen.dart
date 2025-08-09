import 'package:baettori/utils/style.dart';
import 'package:baettori/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 초기화 작업
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_printValue);
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _printValue() {
    print(_searchController.text);
  }

  // 최근 검색어 불러오기
  void _loadRecentSearches() async {
    final snapshot = await _firestore.collection('recent_searches').get();
    setState(() {
      _recentSearches =
          snapshot.docs.map((doc) => doc['search_term'] as String).toList();
    });
  }

  // 최근 검색어 추가하기
  void _addRecentSearch(String searchTerm) async {
    await _firestore
        .collection('recent_searches')
        .add({'search_term': searchTerm});
    _loadRecentSearches(); // 갱신
  }

  // 최근 검색어 삭제하기
  void _removeRecentSearch(int index) async {
    String searchTerm = _recentSearches[index];
    final snapshot = await _firestore
        .collection('recent_searches')
        .where('search_term', isEqualTo: searchTerm)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _loadRecentSearches(); // 갱신
  }

  // 전체 삭제하기
  void _clearRecentSearches() async {
    final snapshot = await _firestore.collection('recent_searches').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _loadRecentSearches(); // 갱신
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: topNavHeight,
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextFormField(
              controller: _searchController,
              onFieldSubmitted: (value) {
                snackBarColor(context, '추후 업데이트를 기대해주세요!');
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mainBlue1,
                hintText: '검색어를 입력해주세요...',
                hintStyle: const TextStyle(color: gray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_search.svg',
                    width: 24,
                  ),
                  onPressed: () {
                    // 검색어 입력 시 처리
                    snackBarColor(context, '추후 업데이트를 기대해주세요!');
                    _addRecentSearch(_searchController.text);
                  },
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: gray),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('최근 검색어',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: gray,
                      )),
                ),
                if (_recentSearches.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: _clearRecentSearches,
                    child: const Text('전체 삭제',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: gray,
                        )),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _recentSearches.isNotEmpty
                ? ListView.separated(
                    itemCount: _recentSearches.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: lightGray),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 20, right: 10),
                        title: Text(_recentSearches[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: gray),
                          onPressed: () {
                            _removeRecentSearch(index);
                          },
                        ),
                        onTap: () {
                          // Handle item tap, for example, set the search text
                          _searchController.text = _recentSearches[index];
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('최근 검색 없음',
                        style: TextStyle(color: Colors.black54)),
                  ),
          ),
        ],
      ),
    );
  }
}

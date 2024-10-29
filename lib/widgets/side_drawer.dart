import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../side_bar/gallery_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Users? userInfo;
  String? majorName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final info = await ApiService.getUserInfo();
      final major = await ApiService.getMajorInfo();
      print(
          'User Info - Name: ${info.userName}, StudentId: ${info.studentId}, MajorId: ${info.majorId}');
      print('Major Name: $major');

      setState(() {
        userInfo = info;
        majorName = major;
        isLoading = false;
      });

      print('Loaded user info: ${info.userName}, Major: $major');
    } catch (e) {
      print('Error loading info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      // 세션 쿠키 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sessionCookie');

      // 로그인 화면으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('로그아웃 중 오류 발생: $e');
      // 사용자에게 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.logoutError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFF87C159),
            ))
          : Column(
              children: [
                // 1. 사용자 프로필 헤더
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF87C159),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Text(
                              userInfo?.userName.substring(0, 1) ?? 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Color(0xFF87C159),
                                fontFamily: 'GmarketSansTTFBold',
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userInfo?.userName ?? 'User Name',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'GmarketSansTTFBold',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  majorName ?? '학과 정보 없음',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'GmarketSansTTFMedium',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. 메뉴 섹션
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // 갤러리 섹션
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: const Icon(
                          Icons.photo_library_outlined,
                          color: Color(0xFF87C159),
                          size: 28,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.gallery,
                          style: const TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFF666666),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GalleryScreen(),
                            ),
                          );
                        },
                      ),

                      // 구분선
                      Divider(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),

                // 3. 하단 로그아웃 버튼
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xFF666666),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.logout,
                      style: const TextStyle(
                        fontFamily: 'GmarketSansTTFMedium',
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    onTap: _logout,
                  ),
                ),
              ],
            ),
    );
  }
}

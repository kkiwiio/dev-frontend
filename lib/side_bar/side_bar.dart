import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../side_bar/image_transform.dart';
import '../login/login.dart';
import './image_storage.dart';

class Sidebar extends StatefulWidget {
  final int rewardPoints;
  final VoidCallback onPointsUpdated;
  final VoidCallback QonpointsUpdated;

  const Sidebar(
      {super.key,
      required this.rewardPoints,
      required this.onPointsUpdated,
      required this.QonpointsUpdated});
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    loadRewardPoints();
  }

  Future<void> loadRewardPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rewardPoints = prefs.getInt('rewardPoints') ?? 0;
    });
    widget.onPointsUpdated();
    widget.QonpointsUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFDCFFB1),
              boxShadow: [],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reward Points',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GmarketSansTTFMedium',
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    '${widget.rewardPoints}',
                    style: const TextStyle(
                      fontFamily: 'GmarketSansTTFMedium',
                      color: Colors.lightBlueAccent,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          ListTile(
            leading: const Icon(
              Icons.man,
              color: Colors.black,
            ),
            title: const Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'GmarketSansTTFMedium',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ImageStorageScreen()),
              );
            },
            trailing: const Icon(Icons.add),
          ),
          const SizedBox(height: 30.0),
          ListTile(
            leading: const Icon(
              Icons.switch_access_shortcut,
              color: Colors.black,
            ),
            title: const Text(
              '생성형이미지 보러가기',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'GmarketSansTTFMedium',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageTransform(
                          rewardPoints: rewardPoints,
                          onPointsUpdated: widget.onPointsUpdated,
                        )),
              ).then((_) {
                loadRewardPoints();
              });
            },
            trailing: const Icon(Icons.add),
          ),
          const SizedBox(height: 30.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '추후에 더 많은 기능들을 만나봐요!😊',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'GmarketSansTTFMedium',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogIn()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'GmarketSansTTFMedium',
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

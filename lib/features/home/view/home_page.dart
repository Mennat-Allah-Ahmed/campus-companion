import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/features/home/view/About_screen.dart';
import 'package:project/features/home/view/models/news_model.dart';
import 'package:project/features/home/view/models/news_model_data.dart';
import 'package:project/features/home/view/schedule_screen.dart';
import 'package:project/features/home/view/widgets/build_image.dart';
import 'package:project/features/home/view/widgets/build_news.dart';
import 'package:project/features/home/view/widgets/notify_user.dart';
import 'package:project/features/home/view/widgets/search_box.dart';
import '../../Services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = 'Guest';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    if (user != null) {
      String? email = user.email;
      if (email != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (doc.exists && doc.data()?['firstName'] != null) {
            setState(() {
              username = (doc.data()!['firstName'] as String).capitalize();
            });
            return;
          }
        } catch (e) {
          print('Error fetching Firestore data: $e');
        }

        final provider = user.providerData
            .firstWhere((data) => data.providerId != 'firebase',
                orElse: () => user.providerData.first)
            .providerId;
        if (provider == 'microsoft.com') {
          final regex = RegExp(r'([a-zA-Z]+)\d+@feng\.bu\.edu\.eg');
          final match = regex.firstMatch(email);
          setState(() {
            username = match?.group(1)?.capitalize() ?? email.split('@').first;
          });
        } else {
          setState(() {
            username = email.split('@').first;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.06,
      vertical: size.height * 0.02,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 20,
                              color: const Color(0xFF445B70),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    NotificationIcon(),
                  ],
                ),
                SizedBox(height: 20),
                SearchBox(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('Navigating to AboutScreen');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          );
                        },
                        child: BuildImageCard(
                          imagePath: 'assets/images/Feng.jpg',
                          label: 'About',
                          width: size.width * 0.45,
                          height: size.height * 0.15,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('Navigating to ScheduleScreen');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ScheduleScreen(),
                            ),
                          );
                        },
                        child: BuildImageCard(
                          imagePath: 'assets/images/Tables.jpg',
                          label: 'Schedule',
                          width: size.width * 0.45,
                          height: size.height * 0.15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Latest News',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ...newsItems.map((news) => Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02),
                      child: BuildNews(
                        imagePath: news.imagePath,
                        description: news.description,
                        date: news.date,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}

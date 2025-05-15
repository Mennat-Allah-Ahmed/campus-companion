import 'package:flutter/material.dart';
import 'package:project/features/home/view/models/about_data.dart';
import 'package:project/features/silver_app_bar_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Handle physical back button
  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(); // Pop to HomePage
    return false; // Prevent default pop
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SilverAppBarWidget(
                appBarText: "About",
                onBackPressed: () => Navigator.of(context).pop(),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/Feng_big.png',
                            fit: BoxFit.cover,
                            height: size.height * 0.45,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ...aboutContent.paragraphs.map(
                          (paragraph) => Padding(
                            padding:
                                EdgeInsets.only(bottom: size.height * 0.015),
                            child: Text(
                              paragraph,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

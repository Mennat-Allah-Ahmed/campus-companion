import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/features/home/view/widgets/detail_not.dart';

class NotificationBox extends StatelessWidget {
  const NotificationBox({super.key});

  Future<List<String>> _fetchNotifications() async {
    // Replace with actual Firestore query for production
    return [
      'Notification 1: Welcome to the app!',
      'Notification 2: New course.',
      'Notification 3: Faculty event.',
      'Notification 4: Lab updated.',
    ];
    // Firestore query:
    // final snapshot = await FirebaseFirestore.instance.collection('notifications').get();
    // return snapshot.docs.map((doc) => doc.data()['message'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRect(
        child: FutureBuilder<List<String>>(
          future: _fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Error loading notifications')),
              );
            }
            final notifications = snapshot.data ?? ['No notifications'];
            // 50px per ListTile + 50px for title + 40px for button + padding
            final estimatedHeight = notifications.length * 50.0 + 90.0;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.6,
                minHeight: 100.0,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.04,
                  size.height * 0.03,
                  size.width * 0.04,
                  size.height * 0.02,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: notifications
                              .asMap()
                              .entries
                              .map(
                                (entry) => ListTile(
                                  leading: Icon(
                                    Icons.notification_important,
                                    size: 16,
                                    color: Color(0xFF445B70),
                                  ),
                                  title: Text(
                                    entry.value,
                                    style: TextStyle(
                                        color: Color(0xFF445B70),
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          NotificationDetailDialog(
                                        message: entry.value,
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Color(0xFF834746),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

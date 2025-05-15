import 'package:flutter/material.dart';
import 'package:project/features/home/view/widgets/notification_box.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  void _showNotificationBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NotificationBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IconButton(
      icon: Icon(
        Icons.notifications_active_outlined,
        size: size.width * 0.06,
      ),
      onPressed: () => _showNotificationBox(context),
    );
  }
}

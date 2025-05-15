import 'package:flutter/material.dart';

class NotificationDetailDialog extends StatelessWidget {
  final String message;

  const NotificationDetailDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRect(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.8,
            maxHeight: size.height * 0.5,
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
                  'Notifications Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Color(0xFF445B70),
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
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
        ),
      ),
    );
  }
}

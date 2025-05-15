import 'package:flutter/material.dart';

class ListTileElements extends StatelessWidget {
  final String titleListTile;
  final Color? iconColor;
  final Color listTileColor;
  final IconData? leadingIcon;
  final VoidCallback? onTap;

  const ListTileElements({
    super.key,
    required this.titleListTile,
    required this.listTileColor,
    this.leadingIcon,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: iconColor,
        size: 16,
      ),
      title: Text(
        titleListTile,
        style: TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: listTileColor,
          fontFamily: "Inter",
        ),
      ),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}

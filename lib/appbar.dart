import 'package:flutter/material.dart';

class USOSBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const USOSBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(this.title, style: TextStyle(fontWeight: FontWeight.bold)));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

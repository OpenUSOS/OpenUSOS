import 'package:flutter/material.dart';

class USOSBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const USOSBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(this.title, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                if (ModalRoute.of(context)!.isCurrent) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                }
                ;
              },
              icon: Icon(Icons.home_filled))
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

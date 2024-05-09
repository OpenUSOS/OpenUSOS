import 'package:flutter/material.dart';
import 'package:open_usos/user_session.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late bool hasImage = true;
  User? _user;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in.');
    }
    debugPrint(UserSession.user!.firstName);
    _user = UserSession.user;
  }

  void tapCallback() => setState(() {
        _isTapped = true;
      });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        clipBehavior: Clip.none,
        child: ListView(children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/c/cd/University-of-Alabama-EngineeringResearchCenter-01.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.shade800,
                    offset: Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  )
                ],
              ),
              child: Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        hasImage
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(_user!.photoUrl),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[400],
                                child: Text(
                                    _user!.firstName[0] + _user!.lastName[0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 40,
                                        color: Colors.black54,
                                        shadows: <Shadow>[
                                          Shadow(
                                            color: Colors.grey.shade600,
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 3.0,
                                          )
                                        ])))
                      ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_user!.firstName + ' ' + _user!.lastName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                shadows: <Shadow>[
                                  Shadow(
                                    blurRadius: 3.0,
                                    offset: Offset(2.0, 2.0),
                                    color: Colors.black,
                                  )
                                ])),
                        SizedBox(
                          height: 20,
                        ),
                        Text(_user!.emailAddr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                shadows: <Shadow>[
                                  Shadow(
                                    blurRadius: 5.0,
                                    offset: Offset(2.0, 2.0),
                                    color: Colors.black,
                                  )
                                ],
                                fontWeight: FontWeight.bold)),
                        Text(_user!.universityName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              shadows: <Shadow>[
                                Shadow(
                                  blurRadius: 5.0,
                                  offset: Offset(2.0, 2.0),
                                  color: Colors.black,
                                )
                              ],
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                )
              ])),
          ListTile(
              title: Text("Oceny"),
              leading: Icon(Icons.grade),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/grades');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Kalendarz"),
              leading: Icon(Icons.calendar_month),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calendar');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("OpenUSOS mail"),
              leading: Icon(Icons.mail),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/email');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Plan zajęć"),
              leading: Icon(Icons.schedule),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/schedule');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Sprawdziany"),
              leading: Icon(Icons.task),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/exams');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Ankiety"),
              leading: Icon(Icons.dynamic_form),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/questionnaires');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Aktualności"),
              leading: Icon(Icons.newspaper),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/news');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Grupy zajęciowe"),
              leading: Icon(Icons.group),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/courses');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Ustawienia"),
              leading: Icon(Icons.settings),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              }),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 5.0,
            thickness: 2.0,
          ),
          ListTile(
              title: Text("Twoje konto"),
              leading: Icon(Icons.person),
              onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user');
              }),
        ]));
  }
}

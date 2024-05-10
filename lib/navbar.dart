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
    Color navTextColor = Colors.white;
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
          buildNavTiles('Oceny', Icons.assessment, '/grades'),
          buildDivider(),
          buildNavTiles('Kalendarz', Icons.calendar_view_month, '/calendar'),
          buildDivider(),
          buildNavTiles('OpenUSOS mail', Icons.mail, '/email'),
          buildDivider(),
          buildNavTiles('Plan zajęć', Icons.calendar_view_day, '/schedule'),
          buildDivider(),
          buildNavTiles('Sprawdziany', Icons.task, '/TODO'),
          buildDivider(),
          buildNavTiles('Ankiety', Icons.question_answer, '/TODO'),
          buildDivider(),
          buildNavTiles('Aktualności', Icons.newspaper, '/TODO'),
          buildDivider(),
          buildNavTiles('Grupy zajęciowe', Icons.group, '/TODO'),
          buildDivider(),
          buildNavTiles('Ustawienia', Icons.settings, '/settings'),
          buildDivider(),
          buildNavTiles('Twoje konto', Icons.person, '/user')
        ]));
  }

  Widget buildNavTiles(String title, IconData iconData, String path) {
    return ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          iconData,
          color: Colors.white,
        ),
        onTap: () {
          tapCallback();
          Navigator.pop(context);
          Navigator.pushNamed(context, path);
        });
  }

  Widget buildDivider() {
    return Divider(
      indent: 20,
      endIndent: 20,
      height: 5.0,
      thickness: 2.0,
    );
  }
}

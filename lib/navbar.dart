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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in.');
    }
    if(UserSession.user == null){
      throw Exception('Failed gettings user data');
    }
    _user = UserSession.user;
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        clipBehavior: Clip.none,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                image: DecorationImage(
                  //for now the image is fetched from Wikipedia page of Jagiellonian University
                  image: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Jagiellonian_University_Collegium_Novum%2C_1882_designed_by_Feliks_Ksi%C4%99%C5%BCarski%2C_24_Go%C5%82%C4%99bia_street%2C_Old_Town%2C_Krakow%2C_Poland.jpg/1280px-Jagiellonian_University_Collegium_Novum%2C_1882_designed_by_Feliks_Ksi%C4%99%C5%BCarski%2C_24_Go%C5%82%C4%99bia_street%2C_Old_Town%2C_Krakow%2C_Poland.jpg'),
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
          buildCategoryHeader('Uczelnia'),
          buildNavTiles(context, 'OpenUSOS mail', Icons.mail, '/emails'),
          buildDivider(),
          buildNavTiles(context, 'Ankiety', Icons.question_answer, '/TODO'),
          buildDivider(),
          buildNavTiles(context, 'Aktualności', Icons.newspaper, '/TODO'),
          buildDivider(),
          buildNavTiles(context, 'Grupy zajęciowe', Icons.group, '/TODO'),
          buildDivider(),
          buildNavTiles(context, 'Twoje rejestracje', Icons.app_registration,
              '/registration'),
          buildCategoryHeader('Inne'),
          buildNavTiles(context, 'Ustawienia', Icons.settings, '/settings'),
          buildDivider(),
          buildNavTiles(context, 'Twoje konto', Icons.person, '/user'),
          buildDivider(),
          buildNavTiles(context, 'Zgłoś błąd', Icons.bug_report, '/bug'),
        ]));
  }

  Widget buildNavTiles(
      BuildContext context, String title, IconData iconData, String path) {
    bool isSelected = ModalRoute.of(context)?.settings.name == path;
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border:
                  Border(right: BorderSide(width: 4.0, color: Colors.white)))
          : null,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          iconData,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, path);
        },
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      indent: 20,
      endIndent: 20,
      height: 5.0,
      thickness: 2.0,
    );
  }

  Widget buildCategoryHeader(String title) {
    return ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
              color: Colors.white,
            )));
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final BottomNavBarIndexStore indexStore = BottomNavBarIndexStore();
  final GlobalKey<_BottomNavBarState> bottomNavBarKey =
      GlobalKey<_BottomNavBarState>();
  Map<String, int> routeToIndex = {
    '/home': 0,
    '/grades': 1,
    '/exams': 2,
    '/schedule': 3,
    '/calendar': 4,
  };

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
        key: bottomNavBarKey,
        data: NavigationBarThemeData(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.blue.shade900
              : Colors.indigo.shade400,
          iconTheme: MaterialStateProperty.all(
            IconThemeData(color: Colors.white),
          ),
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              color: Colors.white,
              fontSize: 11.0,
            ),
          ),
          indicatorColor:
              routeToIndex.keys.contains(ModalRoute.of(context)?.settings.name)
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.blue.shade800
                      : Colors.indigo.shade300
                  : Colors.transparent,
        ),
        child: NavigationBar(
          height: 80.0,
          elevation: 0.0,
          selectedIndex: indexStore.currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              indexStore.currentIndex = index;

              Navigator.popUntil(context, (route) => route == '/home');
              Navigator.pushNamed(context, routeToIndex.keys.elementAt(index));
            });
          },
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.home), label: 'Strona główna'),
            NavigationDestination(icon: Icon(Icons.grade), label: 'Oceny'),
            NavigationDestination(icon: Icon(Icons.task), label: 'Sprawdziany'),
            NavigationDestination(
                icon: Icon(Icons.schedule), label: 'Plan zajęć'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month), label: 'Kalendarz'),
          ],
        ));
  }

  void clearIndex(String route) {
    if (!routeToIndex.containsKey(route)) {
      indexStore.currentIndex = -1;
    }
  }
}

// this class is used to store the current index of bottom navbar globally
class BottomNavBarIndexStore {
  static final BottomNavBarIndexStore _singleton =
      BottomNavBarIndexStore._internal();

  factory BottomNavBarIndexStore() {
    return _singleton;
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(index) {
    _currentIndex = index;
  }

  BottomNavBarIndexStore._internal();
}

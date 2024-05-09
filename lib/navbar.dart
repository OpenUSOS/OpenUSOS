import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  //potrzebne zmienne
  late String imageUrl = '';
  late bool hasImage = false;
  late String name = '';
  late String initials = '';
  late String email = '';
  late String university = '';
  bool _isTapped = false;





  @override
  void initState() {
    super.initState();
    loadData();
  }

  void tapCallback() => setState(() {_isTapped = true;});

  Future<Map<String, dynamic>> getData() async {
    var url = 'http://apiAddres:5000/api/data';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        //status HTTP 200 to OK
        return json.decode(response.body);
      } else {
        //inny status HTTP zwracamy pusta liste
        print('Getting data not possible: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      //error w trakcie pobierania danych
      print('Error: $e');
      return {};
    }
  }

  Future<void> loadData() async {
    var data = await getData();
    setState(() {
      //ustawianie danych
      imageUrl = data['imageUrl'] ?? "http://exampleurl.com/image.jpg";
      hasImage = imageUrl != "http://exampleurl.com/image.jpg";
      name = data['name'] ?? 'User Name';
      email = data['email'] ?? 'user@example.com';
      university = data['university'] ?? 'Example University';
      initials = '';
      List<String> split = name.split(' ');
      split.forEach((element) {
        initials += element[0];
      });
    });
  }
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
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/cd/University-of-Alabama-EngineeringResearchCenter-01.jpg'),
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
                          backgroundImage: NetworkImage(imageUrl),
                        )
                            : CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[400],
                            child: Text(
                                initials,
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
                                    ]
                                )
                            )
                        )
                      ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                shadows: <Shadow>[
                                  Shadow(
                                    blurRadius: 3.0,
                                    offset: Offset(2.0, 2.0),
                                    color: Colors.black,
                                  )
                                ]
                            )
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            email,
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
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                            university,
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
                            )
                        ),
                      ]
                  ),
                )
              ])),
          ListTile(
            title: Text("Oceny"),
            leading: Icon(Icons.grade),
            onTap: () {
                tapCallback();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/grades');
            }
          ),
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
            }
          ),
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
            }
          ),
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
            }
          ),
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
            }

          ),
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
            }
          ),
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
            }
          ),
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
            }
          ),
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
            }
          ),


        ]));
  }
}
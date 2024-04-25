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
  late String imageUrl;
  late bool hasImage = false;
  late String name;
  late String initials;
  late String email;
  late String university;
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
        backgroundColor: Colors.blueGrey.shade900,
        child: ListView(children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/cd/University-of-Alabama-EngineeringResearchCenter-01.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                ),
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
              leading: Icon(Icons.grade,
                  color: Colors.white54),
              tileColor: _isTapped ? Colors.blueGrey[800] : Colors.transparent,
              onTap: () {tapCallback();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/grades');
              },
              title: Text("Grades",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.newspaper,
                  color: Colors.white54),
              onTap: () {tapCallback();},
              title: Text("News",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.schedule,
                  color: Colors.white54),
              title: Text("Schedule",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.group,
                  color: Colors.white54),
              title: Text("Course groups",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.task,
                  color: Colors.white54),
              title: Text("Exams",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.calendar_month,
                  color: Colors.white54),
              title: Text("Calendar",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 2.0,
            color: Colors.white60,
          ),
          ListTile(
              leading: Icon(Icons.email,
                  color: Colors.white54),
              title: Text("USOS Mail",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.dynamic_form,
                  color: Colors.white54),
              title: Text("Questionnaires",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),
          ListTile(
              leading: Icon(Icons.settings,
                  color: Colors.white54),
              title: Text("Settings",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),

          ListTile(
              leading: Icon(Icons.bug_report,
                  color: Colors.white54),
              title: Text("Report a bug",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  )
              )
          ),


        ]));
  }
}
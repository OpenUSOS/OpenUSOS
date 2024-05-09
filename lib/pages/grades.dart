import 'package:flutter/material.dart';

class Grades extends StatefulWidget {
  const Grades({super.key});

  @override
  State<Grades> createState() => GradesState();

}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it public so that it can be tested
@visibleForTesting
class GradesState extends State<Grades> {
  List<Map<String, dynamic>> gradesData = [];

  void initState() {
    super.initState();
    getData();
  }

  Future setData() async {
    gradesData = await getData();
    return;
  }

  Future<List<Map<String, dynamic>>> getData() async {
    return [
      {
        'term': '23/24 Z',
        'subject': 'Programowanie',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '23/24 Z',
        'subject': 'Grafika komputerowa',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '23/24 Z',
        'subject': 'Nienawidze programowania 2',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '23/24 Z',
        'subject': 'Wstęp do piekła',
        'grade': 2.0,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '22/23 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '22/23 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '21/22 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '21/22 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    Color? failed = Colors.red[800];
    Color? passed = Colors.blue[800];
    //zmienna przechowujaca pogrupowane oceny wzgledem semestrow
    var groupedByTerms = {};

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            elevation: 5.0,
            backgroundColor: Colors.blueGrey[900],
            title: Text(
              "Your grades",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    if (ModalRoute.of(context)!.isCurrent) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home');
                    }
                    ;
                  },
                  icon: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ))
            ]),
        body: FutureBuilder(
            future: setData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
              //we group a data into a new list for convenience
                for (var item in gradesData)
                  groupedByTerms.putIfAbsent(item['term'], () => []).add(item);

                return ListView.builder(
                    itemCount: groupedByTerms.entries.length,
                    itemBuilder: (context, index) {
                      var term = groupedByTerms.entries.elementAt(index).key;
                      var gradeDetails =
                          groupedByTerms.entries.elementAt(index).value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            height: 10.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(term,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0))),
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            height: 10.0,
                            color: Colors.grey[400],
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: gradeDetails.length,
                              itemBuilder: (context, subIndex) {
                                var item = gradeDetails[subIndex];
                                return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        item['subject'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle:
                                          Text('given by ${item['professor']}'),
                                      leading: CircleAvatar(
                                        backgroundColor: item['grade'] == 2.0
                                            ? failed
                                            : passed,
                                        radius: 20.0,
                                        child: Text(
                                          '${item['grade']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ));
                              })
                        ],
                      );
                    });
              }
            }));
  }
}

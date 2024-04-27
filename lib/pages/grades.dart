import 'package:flutter/material.dart';



class Grades extends StatefulWidget {
  const Grades({super.key});

  @override
  State<Grades> createState() => GradesState();
}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it publics so that it can be tested
class GradesState extends State<Grades> {
  List<Map<String, dynamic>> gradesData = [];
  void initState() {
    super.initState();
    gradesData = getData();
  }
  List<Map<String, dynamic>> getData() {
    return [
      {'term': '23/24 Z', 'subject': 'Programowanie', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '23/24 Z', 'subject': 'Grafika komputerowa', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '23/24 Z', 'subject': 'Nienawidze programowania 2', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '23/24 Z', 'subject': 'Wstęp do piekła', 'grade': 2.0, 'professor': 'Rafael Coffee'},
      {'term': '22/23 Z', 'subject': 'Sranie 1', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '22/23 Z', 'subject': 'Sranie 1', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '21/22 Z', 'subject': 'Sranie 1', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '21/22 L', 'subject': 'Sranie 1', 'grade': 4.5, 'professor': 'Rafael Coffee'},
      {'term': '21/22 Z', 'subject': 'Sranie 1', 'grade': 4.5, 'professor': 'Rafael Coffee'},
    ];
  } 

  @override
  Widget build(BuildContext context) {
    //zmienna przechowujaca pogrupowane oceny wzgledem semestrow
    var groupedByTerms = {};

    //grupujemy w nowej mapie map
    for (var item in gradesData) 
      groupedByTerms.putIfAbsent(item['term'], () => []).add(item); 

    return Scaffold(
      appBar: AppBar(
                title: Text(
          "Your grades",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if(ModalRoute.of(context)!.isCurrent) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home'); 
              };
            },
            icon: Icon(Icons.home_filled,)
          )
        ]
      ),
      body: ListView.builder(
        itemCount: groupedByTerms.entries.length,
        itemBuilder: (context, index) {  
          var term = groupedByTerms.entries.elementAt(index).key;
          var gradeDetails = groupedByTerms.entries.elementAt(index).value;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text( 
                  term,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  )
                )
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gradeDetails.length, 
                itemBuilder: (context, subIndex) {
                  var item = gradeDetails[subIndex];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text(item['subject']),
                      subtitle: Text('given by ${item['professor']}'),
                      leading: CircleAvatar(
                        backgroundColor: item['grade'] == 2.0 ? Colors.redAccent[700] : Colors.blue[700],
                        radius: 20.0,
                        child: Text(
                          '${item['grade']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ), 
                        ),
                      ),
                    )
                  );
                }
              )
            ],
          );
        }
      )
    );
  }
}


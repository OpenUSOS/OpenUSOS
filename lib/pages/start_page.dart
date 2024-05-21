import 'package:flutter/material.dart';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';

class StartPage extends StatelessWidget {
  final List<String> UniversityList = [
    "AMISNS",
    "Akademia Nauk Stosowanych Stefana Batorego",
    "Akademia Wychowania Fizycznego im. Bronisława Czecha w Krakowie",
    "Chrześcijańska Akademia Teologiczna w Warszawie",
    "Jan Dlugosz University in Czestochowa",
    "Medical University of Lublin",
    "National Academy of Dramatic Art in Warsaw",
    "PWSTE w Jarosławiu",
    "SGH Warsaw School of Economics",
    "The Academy of Fine Arts and Design in Katowice",
    "The Adam Mickiewicz University in Poznan",
    "The Angelus Silesius University of Applied Sciences",
    "The Bialystok School of Economics",
    "The Bielska Wyższa Szkoła im. J. Tyszkiewicza",
    "The Bydgoszcz University of Science and Technology",
    "The Cardinal Stefan Wyszynski University",
    "The Cracow University of Economic",
    "The Czestochowa University of Technology",
    "The DSW University of Lower Silesia",
    "The Feliks Nowowiejski Academy of Music",
    "The Fire University",
    "The Gdynia Maritime University",
    "The Helena Chodkowska University of Law in Wrocław",
    "The Higher School of Management Personnel",
    "The Hipolit Cegielski State University of Applied Sciences in Gniezno",
    "The Jagiellonian University",
    "The Jerzy Kukuczka Academy of Physical Education in Katowice",
    "The Jesuit University Ignatianum in Krakow",
    "The Kazimierz Wielki University",
    "The Kielce University of Technology",
    "The Krosno Academy of Applied Sciences",
    "The Military University of Technology in Warsaw",
    "The Nicolaus Copernicus University",
    "The Non-public School of Medicine in Wrocław",
    "The OSW",
    "The Opole University of Technology",
    "The Pontifical Faculty of Theology in Wrocław",
    "The Pontifical University of John Paul II",
    "The Poznan University of Physical Education",
    "The Poznan University of Technology",
    "The Poznań University of Economics and Business",
    "The Rzeszów University of Technology",
    "The Silesian University of Technology",
    "The Stanisław Staszic State University of Applied Sciences in Piła",
    "The State University of Applied Sciences",
    "The State University of Applied Sciences in Głogów",
    "The Technical University of Koszalin",
    "The University College of Applied Sciences in Chelm",
    "The University University of Technology and Economics",
    "The University of APS",
    "The University of Agriculture",
    "The University of Bialystok",
    "Politechnika Białostocka",
    "The University of Bielsko-Biała",
    "The University of Economics in Katowice",
    "The University of Euroregional Economy in Józefów - Warsaw",
    "The University of Lodz",
    "The University of Maria Curie-Skłodowska",
    "The University of Opole",
    "The University of Siedlce",
    "The University of Silesia in Katowice",
    "The University of Warmia and Mazury in Olsztyn",
    "The University of Warsaw",
    "The University of Wroclaw",
    "The University of Wąchock",
    "The University of the National Education Commission",
    "The Warsaw University of Technology",
    "The Wroclaw University of Economics",
    "The Wrocław Medical University",
    "The Wrocław University of Environmental and Life Science",
    "The Wyższa Szkoła Turystyki i Ekologii",
    "The president Stanisław Wojciechowski Higher Vocational State School in Kalisz",
    "UP Sanok",
    "University of Lomza",
    "Uniwerstytet Muzyczny Fryderyka Chopina",
    "VISTULA UNIVERSITY",
    "WAB",
    "Wyższa Szkoła Bezpieczeństwa Publicznego i Indywidualnego „Apeiron” w Krakowie",
    "Wyższa Szkoła Kryminologii i Penitencjarystyki w Warszawie",
    //link doesn't seem to work? "http://apps.nencki.usos.pcss.pl/",
    //link doesn't seem to work? "http://apps.wsb.net.pl/",
    "ANS Leszno"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'OpenUSOS'),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Witaj w aplikacji OpenUSOS, która pozwoli ci zarządzać swoim kontem USOS.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Aby korzystać z funkcji aplikacji zaloguj się kilkając w przycisk poniej.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Wybierz swoją uczelnię',
                  textAlign: TextAlign.center,
                ),
                Column(
                    children:[
                      Text('Język'),
                      DropdownButton<String>(
                      value: UserSession.currentlySelectedUniversity,
                      onChanged: (String? value) {
                        UserSession.currentlySelectedUniversity = value!;
                      },
                      items: UniversityList
                          .map<DropdownMenuItem<String>>((String university) {
                        return DropdownMenuItem<String>(
                          value: university,
                          child: Text(university),
                        );
                      }).toList(),
                    )
                ]),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Przejdź dalej'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                    ))
              ])),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';

import 'package:open_usos/user_session.dart';
import 'package:open_usos/navbar.dart';
import 'package:open_usos/appbar.dart';


class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future<void> _futureNews;
  List<NewsArticle>? news;

  @override
  void initState() {
    super.initState();
    _futureNews = fetchNews('2024-01-01', '0', '90');
  }

  Future<void> fetchNews(
      String startDay, String startIndex, String newsAmount) async {
    if (UserSession.sessionId == null) {
      throw Exception("sessionId is null, user not logged in.");
    }


    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_news',
      'query2': startDay,
      'query3': startIndex,
      'query4': newsAmount,
    });


    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<NewsArticle> articles = [];
      for (var item in data['items']) { 
        var articleData = item['article'];
        articles.add(NewsArticle.fromJson(articleData));
      }
      setState(() {
        news = articles;
      });
    } else {
      throw Exception(
          "failed to fetch data, HTTP status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: USOSBar(title: "Aktualności"),
        bottomNavigationBar: BottomNavBar(),
        drawer: NavBar(),
        body: FutureBuilder(
            future: _futureNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                if (news != null) {
                return ListView.builder(
                  itemCount: news!.length,
                  itemBuilder: (context, index) {
                    return NewsArticleWidget(article: news![index]);
                  }
                );
                } else {
                return Center(child: Text("Brak aktualności"));
                } 
              }
            }));
  }
}

class NewsArticle {
  final String name;
  final String author;
  final String publicationDate;
  final String title;
  final String headlineHtml;
  final String contentHtml;

  NewsArticle({
    required this.name,
    required this.author,
    required this.publicationDate,
    required this.title,
    required this.headlineHtml,
    required this.contentHtml,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      name: json['name'] != null ? (json['name']['pl'] ?? '') : '',
      author: json['author'] != null ? (json['author'] ?? '') : '',
      publicationDate: json['publication_date'] ?? '',
      title: json['title'] != null ? (json['title']['pl'] ?? '') : '',
      headlineHtml: json['headline_html'] != null ? (json['headline_html']['pl'] ?? '') : '',
      contentHtml: json['content_html'] != null ? (json['content_html']['pl'] ?? '') : '',
    );
  }
}

class NewsArticleWidget extends StatelessWidget {
  
  final NewsArticle article;

  const NewsArticleWidget({Key? key, required this.article}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title, 
              style: TextStyle(fontWeight: FontWeight.bold,
              )
            ),
            SizedBox(height: 8.0),
            Text("Napisano przez: " + article.author,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              )
            ),
            SizedBox(height: 8.0),
            Html(data: article.headlineHtml),
            SizedBox(height: 8.0),
            Html(data: article.contentHtml),
          ]
        )
      ),
      elevation: 10.0,
    );
  }
}

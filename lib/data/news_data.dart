import 'dart:convert';

import 'package:news_app/models/articel_model.dart';
import 'package:http/http.dart' as http;

class NewsData {
  List<ArticelModel> news = [];
  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=id&apiKey=bfd5b46e44594a95bac28fac1f753625";
    var response =await http.get(url);
    var decodeJson = jsonDecode(response.body);
    if (decodeJson['status'] == "ok") {
      decodeJson['articles'].forEach(
        (json) {
          if (json['urlToImage'] != null && json['description'] != null) {
            ArticelModel articelModel=ArticelModel(
              titile: json['title'],
              author: json['author'],
              description: json['description'],
              url: json['url'],
              urlToImage: json['urlToImage'],
              content: json['content']
            );
            news.add(articelModel);
          }
        }
      );
    }
  }
}
class CategoryNews{
  List<ArticelModel> news = [];
  Future<void> getNews(String category) async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=id&category=$category&apiKey=bfd5b46e44594a95bac28fac1f753625";
    var response = await http.get(url);
    var decodeJson = jsonDecode(response.body);
    if (decodeJson['status'] == "ok") {
      decodeJson['articles'].forEach(
        (json) {
          if (json['urlToImage'] != null && json['description'] != null) {
            ArticelModel articelModel=ArticelModel(
              titile: json['title'],
              author: json['author'],
              description: json['description'],
              url: json['url'],
              urlToImage: json['urlToImage'],
              content: json['content']
            );
            news.add(articelModel);
          }
        }
      );
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newnewsapp/model/categories_news_model.dart';
import 'package:newnewsapp/model/news_channel_headlines_model.dart';

class NewsRepository {
  
  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi(
      String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=bf395ad99bce47ce96eaf539b0b6bc7e';

    final response = await http.get(Uri.parse(url));

    // if (kDebugMode) {
    //   print(response.body);
    // }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }

    throw Exception('error');
  }

   Future<CategoriesNewsModel> fetchCategoriesNewsApi(
      String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=bf395ad99bce47ce96eaf539b0b6bc7e';

    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }

    throw Exception('error');
  }

}

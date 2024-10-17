
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newnewsapp/model/news_channel_headlines_model.dart';

class NewsRepository {

  String url = 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=bf395ad99bce47ce96eaf539b0b6bc7e';

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi() async {
    final response = await http.get(Uri.parse(url));

    if(kDebugMode){
      print(response.body);
    }

    if (response.statusCode == 200){

      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);

    }

    throw Exception('error');
  }

}
import 'package:newnewsapp/model/categories_news_model.dart';
import 'package:newnewsapp/model/news_channel_headlines_model.dart';
import 'package:newnewsapp/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  String channelName;

  NewsViewModel({required this.channelName});

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadLinesApi() async {
    final response = await _rep.fetchNewChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}

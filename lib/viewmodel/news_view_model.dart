import 'package:newnewsapp/model/news_channel_headlines_model.dart';
import 'package:newnewsapp/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadLinesApi() async {
    final response = await _rep.fetchNewChannelHeadlinesApi();
    return response; 
  } 
}
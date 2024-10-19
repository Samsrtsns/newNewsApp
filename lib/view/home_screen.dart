import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newnewsapp/model/categories_news_model.dart';
import 'package:newnewsapp/model/news_channel_headlines_model.dart';
import 'package:newnewsapp/view/categories_screen.dart';
import 'package:newnewsapp/view/news_detail_screen.dart';
import 'package:newnewsapp/viewmodel/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = 'bbc-news';

  late NewsViewModel newsViewModel;

  final format = DateFormat('MMMM dd, yyyy');

  final Map<String, String> newsSources = {
    'bbc-news': 'BBC',
    'cnn': 'CNN',
    'techcrunch': 'TechCrunch',
  };

  @override
  void initState() {
    super.initState();
    newsViewModel = NewsViewModel(channelName: name);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesScreen()));
          },
          icon: Image.asset(
            'assets/icons/category_icon.png',
            width: 22,
            height: 22,
          ),
        ),
        title: Text(
          'NEWS',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<String>(
            enableFeedback: false,
            splashRadius: 0,
            color: Colors.white,
            child: const Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 28,
            ),
            onSelected: (String value) {
              setState(() {
                name = value;
                newsViewModel = NewsViewModel(channelName: name);
              });
            },
            itemBuilder: (BuildContext context) {
              return newsSources.entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key, // API'deki değer
                  child: Text(entry.value), // Görüntülemek istediğiniz değer
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // horizontal news section
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadLinesApi(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      size: 50,
                      color: Colors.orange.shade800,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                newsTitle: snapshot.data!.articles![index].title
                                    .toString(),
                                newsImage: snapshot
                                    .data!.articles![index].urlToImage
                                    .toString(),
                                newsDate: snapshot
                                    .data!.articles![index].publishedAt
                                    .toString(),
                                author: snapshot.data!.articles![index].author
                                    .toString(),
                                decription: snapshot
                                    .data!.articles![index].description
                                    .toString(),
                                content: snapshot.data!.articles![index].content
                                    .toString(),
                                source: snapshot.data!.articles![index].author
                                    .toString(),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * .6,
                                width: width * .9,
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * .02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: spinKit2,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white.withOpacity(0.8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    height: height * 0.22,
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * .7,
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 22, right: 8),
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: width * .7,
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.blue.shade800),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // General news section
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.orange.shade800,
                      size: 50,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      String? imageUrl =
                          snapshot.data!.articles![index].urlToImage;
                      if (imageUrl == null || imageUrl.isEmpty) {
                        return const SizedBox();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  width: width * 0.3,
                                  height: height * 0.18,
                                  placeholder: (context, url) => const SizedBox(
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error_outline,
                                          color: Colors.red),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding:
                                      const EdgeInsets.only(left: 16, right: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black, fontSize: 13),
                                        maxLines: 4,
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 90,
                                            child: Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString()
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                color: Colors.orange.shade900,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime).toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade500,
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.black,
  size: 30,
);

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newnewsapp/model/categories_news_model.dart';
import 'package:newnewsapp/repository/news_repository.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsRepository newsRepository = NewsRepository();

  final format = DateFormat('MMMM dd, yyyy');

  String categoryNames = 'general';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          'CATEGORIES',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  canRequestFocus: false,
                  excludeFromSemantics: false,
                  autofocus: false,
                  enableFeedback: false,
                  onTap: () {
                    setState(() {
                      categoryNames = categoriesList[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: categoryNames == categoriesList[index]
                              ? Colors.orange.shade500
                              : Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            categoriesList[index].toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsRepository.fetchCategoriesNewsApi(categoryNames),
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
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      String ? imageUrl = snapshot.data!.articles![index].urlToImage;
                      print(imageUrl);
                      if(imageUrl == null || imageUrl.isEmpty) {
                         return SizedBox();
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

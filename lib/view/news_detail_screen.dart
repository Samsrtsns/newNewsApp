import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsImage,
      newsTitle,
      newsDate,
      author,
      decription,
      content,
      source;

  const NewsDetailScreen({
    super.key,
    required this.newsTitle,
    required this.newsImage,
    required this.newsDate,
    required this.author,
    required this.decription,
    required this.content,
    required this.source,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    print("News Title: ${widget.newsTitle}");
    print("News Image: ${widget.newsImage}");
    print("News Date: ${widget.newsDate}");
    print("Author: ${widget.author}");
    print("Description: ${widget.decription}");
    print("Content: ${widget.content}");
    print("Source: ${widget.source}");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    DateTime dateTime = DateTime.parse(widget.newsDate);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          'DETAIL',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: SizedBox(
                height: height * .45,
                child: CachedNetworkImage(
                  imageUrl: widget.newsImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: height * .4,
              margin: EdgeInsets.only(top: height * .3),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: ListView(
                  children: [
                    Text(
                      widget.newsTitle,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.source,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          format.format(dateTime),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.decription,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      widget.content,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}

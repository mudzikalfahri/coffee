import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coffee/namelist.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  final String title;
  final int item;
  DetailPage({
    Key? key,
    required this.title,
    required this.item,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<AiringDetail> detail;

  @override
  void initState() {
    super.initState();
    detail = fetchDetails(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Detail Anime',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<AiringDetail>(
          future: detail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Column(
                children: [
                  Container(
                    height: 350,
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(snapshot.data!.image),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data!.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20.0,
                    ),
                    Text(
                      snapshot.data!.score.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      snapshot.data!.synopsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ],
              ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Request Failed'));
            }
            return Padding(
                child: Center(
                    child: Loading(
                  indicator: BallSpinFadeLoaderIndicator(),
                  size: 50.0,
                  color: Colors.black,
                )),
                padding: const EdgeInsets.only(top: 100));
          },
        )),
      ),
    );
  }
}

class AiringDetail {
  String image;
  String title;
  String synopsis;
  num malId;
  num score;

  AiringDetail(
      {required this.image,
      required this.title,
      required this.synopsis,
      required this.malId,
      required this.score});

  factory AiringDetail.fromJson(json) {
    return AiringDetail(
      image: json['image_url'],
      title: json['title'],
      synopsis: json['synopsis'],
      malId: json['mal_id'],
      score: json['score'],
    );
  }
}

Future<AiringDetail> fetchDetails(malId) async {
  String api = 'https://api.jikan.moe/v3/anime/$malId';
  var response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    return AiringDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coffee/detail.dart';
import 'package:coffee/namelist.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<AiringModel>> airing;
  late Future<List<Top>> top;

  @override
  void initState() {
    super.initState();
    airing = fetchAiring();
    top = fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Hinataku App'),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profiles(),
                    ),
                  ),
              icon: Icon(
                Icons.manage_accounts_rounded,
                size: 24,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 260.0,
                child: FutureBuilder<List<AiringModel>>(
                    future: airing,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    item: snapshot.data![index].malId,
                                    title: snapshot.data![index].title,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              child: Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                        height: 200,
                                        child: Image.network(
                                            snapshot.data![index].image)),
                                    Column(
                                      children: [
                                        Text(
                                          snapshot.data![index].title,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 12.0,
                                              ),
                                              Text(
                                                snapshot.data![index].rating
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ]),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                          child: Center(
                              child: Loading(
                            indicator: BallSpinFadeLoaderIndicator(),
                            size: 50.0,
                            color: Colors.black,
                          )),
                          padding: const EdgeInsets.only(top: 30));
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 20),
              child: Text(
                'Top Anime',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: SizedBox(
                // height: 200.0,
                child: FutureBuilder<List<Top>>(
                    future: top,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            leading: Image.network(
                              snapshot.data![index].imageUrl,
                            ),
                            title: Text(snapshot.data![index].title),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 18.0,
                                ),
                                Text(snapshot.data![index].score.toString()),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    title: snapshot.data![index].title,
                                    item: snapshot.data![index].malId,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Padding(
                          child: Center(
                              child: Loading(
                            indicator: BallSpinFadeLoaderIndicator(),
                            size: 50.0,
                            color: Colors.black,
                          )),
                          padding: const EdgeInsets.only(top: 60));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiringModel {
  final int malId;
  final String title;
  final num rating;
  final String image;

  AiringModel({
    required this.rating,
    required this.title,
    required this.image,
    required this.malId,
  });

  factory AiringModel.fromJson(Map<String, dynamic> json) {
    return AiringModel(
      malId: json['mal_id'],
      title: json['title'],
      rating: json["score"],
      image: json['image_url'],
    );
  }
}

//fetch api

Future<List<AiringModel>> fetchAiring() async {
  String api = 'https://api.jikan.moe/v3/top/anime/1/airing';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    var airingRes = jsonDecode(response.body)['top'] as List;

    return airingRes.map((airing) => AiringModel.fromJson(airing)).toList();
  } else {
    throw Exception('Request failed');
  }
}

class Top {
  final int malId;
  final String title;
  final String imageUrl;
  final num score;

  Top({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
  });

  factory Top.fromJson(Map<String, dynamic> json) {
    return Top(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      score: json['score'],
    );
  }
}

Future<List<Top>> fetchShows() async {
  String api = 'https://api.jikan.moe/v3/top/anime/1';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['top'] as List;

    return topShowsJson.map((top) => Top.fromJson(top)).toList();
  } else {
    throw Exception('Request failed');
  }
}

/* Testing purposes at the moment */
import 'dart:convert';

CryptosData CryptosDataFromJson(String str) => CryptosData.fromJson(json.decode(str));
//String NewsDataToJson(NewsData data) => json.encode(data.toJson());

class CryptosData {
  CryptosData({
    required this.articles
  });
  List<Cryptos> articles;

  factory CryptosData.fromJson(Map<String, dynamic> json) => CryptosData(
    articles: List<Cryptos>.from(json['articles'].map((x) => Cryptos.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Cryptos {
  Cryptos({
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.urlToImage,
    required this.url,
    required this.content,
    required this.source,
  });

  String title;
  String description;
  String publishedAt;
  String urlToImage;
  String url;
  String content;
  Source source;

  factory Cryptos.fromJson(Map<String, dynamic> json) => Cryptos(
    title: json['title'].toString(),
    description: json['description'].toString(),
    publishedAt: json['publishedAt'].toString(),
    urlToImage: json['urlToImage'].toString(),
    url: json['url'].toString(),
    content: json['content'].toString(),
    source: Source.fromJson(json['source']),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "publishedAt": publishedAt,
    "urlToImage": urlToImage,
    "url": url,
    "content": content,
    "source": source,
  };
}

class Source {
  Source({
    required this.name,
  });

  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

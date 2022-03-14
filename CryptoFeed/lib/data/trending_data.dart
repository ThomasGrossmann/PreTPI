/* Testing purposes at the moment */
import 'dart:convert';

TrendingData TrendingDataFromJson(String str) => TrendingData.fromJson(json.decode(str));

class TrendingData {
  TrendingData({
    required this.coins
  });
  List<Trending> coins;

  factory TrendingData.fromJson(Map<String, dynamic> json) => TrendingData(
    coins: List<Trending>.from(json["coins"]['items'].map((x) => Trending.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "coins": List<dynamic>.from(coins.map((x) => x.toJson())),
  };
}

class Trending {
  Trending({
   required this.id,
   required this.name,
   required this.symbol,
   required this.large,
  });

  String id;
  String name;
  String symbol;
  String large;

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
    id: json['id'].toString(),
    name: json['name'].toString(),
    symbol: json['symbol'].toString(),
    large: json['large'].toString(),
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "large": large,
  };
}

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/data/all.dart';
import 'package:untitled2/widget/all.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}
class _TrendingPageState extends State<TrendingPage> {
  static List<Trending> _trending = [];

  RefreshController controller = RefreshController(initialRefresh: true);

  Future<bool> getTrending({bool isRefresh = true}) async {
    if (isRefresh == false) {
      controller.loadNoData();
      return false;
    }
    final response = await http
        .get(Uri.parse("https://api.coingecko.com/api/v3/search/trending"));

    if (response.statusCode == 200) {
      final result = TrendingDataFromJson(response.body);

      if (isRefresh == true) {
        _trending = result.coins;
      }

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Widget _buildTrending() {
    return Scaffold(
        body: SmartRefresher(
          controller: controller,
          onRefresh: () async {
            final result = await getTrending(isRefresh: true);
            if (result) {
              controller.refreshCompleted();
            } else {
              controller.refreshFailed();
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _trending.length,
            itemBuilder: (context, index) {
              final trending = _trending[index];
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.network(trending.item.large),
                      title: Text(trending.item.name),
                      subtitle: Text(trending.item.symbol),
                      trailing: Text('#${index + 1}'),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    getTrending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Trending Searches'),
        centerTitle: true,
      ),
      body: _buildTrending(),
    );
  }
}

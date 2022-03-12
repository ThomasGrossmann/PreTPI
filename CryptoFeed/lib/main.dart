import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'data/news_data.dart';
import 'data/trending_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoFeed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: null,
          ),
          ListTile(
            title: const Text('News Feed'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Cryptocurrencies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CryptoPage()),
              );
            },
          ),
          ListTile(
            title: const Text('My transactions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransactionsPage()),
              );
            },
          ),
          ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage())
                );
              }
          )
          /*ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),*/
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  static List<Trending> _trending = [];
  
  RefreshController controller = RefreshController(initialRefresh: true);
  
  Future<bool> getTrending({bool isRefresh = false}) async {
    if (isRefresh == false) {
      controller.loadNoData();
      return false;
    }
    final response = await http.get(Uri.parse("https://api.coingecko.com/api/v3/search/trending"));

    if(response.statusCode == 200) {
      final result = TrendingDataFromJson(response.body);

      if(isRefresh == true) {
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
        enablePullUp: true,
        onRefresh: () async {
          final result = await getTrending(isRefresh: true);
          if (result) {
            controller.refreshCompleted();
          } else {
            controller.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getTrending(isRefresh: false);
          if (result) {
            controller.loadComplete();
          } else {
            controller.loadFailed();
          }
          LoadStyle.ShowWhenLoading;
        },
        child: null,//TODO : Display Trendings in HomePage
      )
    );
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
        title: const Text('Trending'),
        centerTitle: true,
      ),
      body: _buildTrending(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}
class _NewsPageState extends State<NewsPage> {
  static List<News> _news = [];
  int currentPage = 1;
  int totalPages = 4;

  RefreshController controller = RefreshController(initialRefresh: true);

  Future<bool> getNews({bool isRefresh = false}) async {
    if (isRefresh == true) {
      currentPage = 1;
    } else {
      if (currentPage >= totalPages) {
        controller.loadNoData();
        return false;
      }
    }
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=crypto&apiKey=e05f822b086d44e7886db0ebbe4d54f6&q=crypto&page=$currentPage&pageSize=10&sortBy=publishedAt"));

    if (response.statusCode == 200) {
      final result = NewsDataFromJson(response.body);

      if (isRefresh == true) {
        _news = result.articles;
      } else {
        _news.addAll(result.articles);
      }

      currentPage++;

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Widget _buildNews() {
    return Scaffold(
      body: SmartRefresher(
        controller: controller,
        enablePullUp: true,
        onRefresh: () async {
          final result = await getNews(isRefresh: true);
          if (result) {
            controller.refreshCompleted();
          } else {
            controller.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getNews(isRefresh: false);
          if (result) {
            controller.loadComplete();
          } else {
            controller.loadFailed();
          }
          LoadStyle.ShowWhenLoading;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _news.length,
          itemBuilder: (context, index) {
            final news = _news[index];
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(news.source.name),
                    title: Text(news.title),
                    subtitle: Text(news.description),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return OneNewsPage(news.source, news.url, news.urlToImage,
                            news.title, news.publishedAt, news.content, news.description);
                      }));
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('News en direct'),
        centerTitle: true,
      ),
      body: _buildNews(),
    );
  }
}

class OneNewsPage extends StatefulWidget {
  final Source source;
  final String url;
  final String urlToImage;
  final String title;
  final String publishedAt;
  final String content;
  final String description;

  OneNewsPage(this.source, this.url, this.urlToImage, this.title, this.publishedAt, this.content, this.description);

  @override
  State<OneNewsPage> createState() => _OneNewsPageState();
}
class _OneNewsPageState extends State<OneNewsPage> {

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);
    if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 1) {
      return 'a day ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inHours == 1) {
      return 'an hour ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inMinutes == 1) {
      return 'a minute ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime ago = DateTime.parse(widget.publishedAt);
    return Scaffold(
        appBar: AppBar(
          title: const Text('MOCKUP DETAILLED NEWS'),
          centerTitle: true,
        ),
        body: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 23),
                  textAlign: TextAlign.justify,
                ),
                subtitle: Text(widget.source.name),
                onTap: () => url.launch(widget.url, forceWebView: true),
              ),
              Container(
                child: Image.network(
                    widget.urlToImage,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.amber,
                        alignment: Alignment.center,
                        child: const Text('Error loading image !', style: TextStyle(fontSize: 30),),
                      );
                    },
                  ),
              ),
              ListTile(
                subtitle: Text(convertToAgo(ago)),
                title: Text(widget.content),
              )
            ],
        ),
    );
  }
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}
class _CryptoPageState extends State<CryptoPage> {
  List<dynamic> _cryptos = [];

  List<DropdownMenuItem<String>> get listCurrencies {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        child: Text('CHF'),
        value: 'chf',
      ),
      const DropdownMenuItem(
        child: Text('EUR'),
        value: 'eur',
      ),
      const DropdownMenuItem(
        child: Text('USD'),
        value: 'usd',
      ),
    ];
    return menuItems;
  }

  void getCryptos() async {
    var result =
        await http.get(Uri.parse("https://api.coingecko.com/api/v3/coins"));
    setState(() {
      _cryptos = json.decode(result.body);
    });
  }

  String holder = 'usd';

  void getDropDownItem() {
    setState(() {
      holder = selectedValue;
    });
  }

  Widget _buildCryptos() {
    String currency = holder.toUpperCase();
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _cryptos.length,
        itemBuilder: (BuildContext context, int index) {
          String image = _cryptos[index]['image']['large'];
          String id = _cryptos[index]['id'];
          return Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(image),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(_cryptos[index]['name']),
                  subtitle: Text(_cryptos[index]['market_data']['current_price']
                              [holder]
                          .toString() +
                      " $currency"),
                  trailing: const Icon(Icons.favorite),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCryptos();
  }

  String selectedValue = 'usd';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Cryptomonnaies'),
        centerTitle: true,
        actions: <Widget>[
          DropdownButton(
            icon: const Icon(Icons.price_change),
            items: listCurrencies,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value!;
              });
              getDropDownItem();
            },
            value: selectedValue,
          )
        ],
      ),
      body: Container(
        child: _buildCryptos(),
      ),
    );
  }
}

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}
class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Transactions'),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: const Text('Return to home page'),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  nameController.text = "";
                  passwordController.text = "";
                },
              )),
        ],
      ),
    );
  }
}

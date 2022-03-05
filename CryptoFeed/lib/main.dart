import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

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
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('News en direct'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Cryptomonnaies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CryptoPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Mes transactions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransactionsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage()),
              );
            },
          ),
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
  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: const Center(
        child: Text('Hello'),
      ),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}
class _NewsPageState extends State<NewsPage> {
  List<dynamic> _news = [];

  void getNews() async {
    var result = await http.get(Uri.parse(
        "https://cryptopanic.com/api/v1/posts/?auth_token=ad15ecca83498d46e8e9e34dd2f18a2ba1320bc4&public=true"));
    setState(() {
      _news = json.decode(result.body)['results'];
    });
  }

  Widget _buildNews() {
    return _news.isNotEmpty
        ? RefreshIndicator(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _news.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(_news[index]['title']),
                  subtitle: Text(_news[index]['domain']),
                  onTap: (){Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const OneNewsPage()));},
                )
              ],
            ),
          );
        },
      ),
      onRefresh: _getValues,
    )
        : const Center(child: CircularProgressIndicator());
  }

  Future<void> _getValues() async {
    setState(() {
      getNews();
    });
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
      body: Container(
        child: _buildNews(),
      ),
    );
  }
}
class OneNewsPage extends StatefulWidget {
  const OneNewsPage({Key? key}) : super(key: key);

  @override
  State<OneNewsPage> createState() => _OneNewsPageState();
}
class _OneNewsPageState extends State<OneNewsPage> {
  // Testing purposes, hard values will be replaced with dynamic API values
  String oneNewsDomain = 'protos.com';
  String oneNewsTitle = 'Disgruntled BlockFi users push class-action after record SEC settlement';
  String oneNewsPublishedAt = '2022-03-02T19:58:45Z';
  String oneNewsId = '14454129';
  String oneNewsPositiveVotes = '0';
  String oneNewsNegativeVotes = '0';
  String oneNewsImportantVotes = '0';
  //

  String convertToAgo(DateTime input){
    Duration diff = DateTime.now().difference(input);
    if(diff.inDays >= 1){
      return '${diff.inDays} days ago';
    } else if(diff.inDays == 1){
      return 'a day ago';
    } else if(diff.inHours >= 1){
      return '${diff.inHours} hours ago';
    } else if(diff.inHours == 1){
      return 'an hour ago';
    } else if(diff.inMinutes >= 1){
      return '${diff.inMinutes} minutes ago';
    } else if(diff.inMinutes == 1){
      return 'a minute ago';
    } else if (diff.inSeconds >= 1){
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime oneNewsDate = DateTime.parse(oneNewsPublishedAt);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOCKUP DETAILLED NEWS'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget> [
          InkWell(
            child: Text(oneNewsTitle),
            onTap: () => url.launch('https://cryptopanic.com/news/$oneNewsId/click/', enableJavaScript: true),
          ),
          Text(convertToAgo(oneNewsDate)),
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
      const DropdownMenuItem(child: Text('CHF'), value: 'chf',),
      const DropdownMenuItem(child: Text('EUR'), value: 'eur',),
      const DropdownMenuItem(child: Text('USD'), value: 'usd',),
    ];
    return menuItems;
  }

  void getCryptos() async {
    var result = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins"));
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
    return _cryptos.isNotEmpty
        ? RefreshIndicator(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _cryptos.length,
        itemBuilder: (BuildContext context, int index) {
          String image = _cryptos[index]['image']['large'];
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
                  subtitle: Text(_cryptos[index]['market_data']['current_price'][holder].toString()+" $currency"),
                  trailing: const Icon(Icons.favorite),
                )
              ],
            ),
          );
        },
      ),
      onRefresh: _getCryptos,
    )
        : const Center(child: CircularProgressIndicator());
  }

  Future<void> _getCryptos() async {
    setState(() {
      getCryptos();
    });
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomePage()));
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
              )
          ),
        ],
      ),
    );
  }
}
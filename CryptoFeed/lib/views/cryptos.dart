import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/widget/all.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/views/all.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  List<dynamic> _cryptos = [];
  final ScrollController _scrollController = ScrollController();
  RefreshController controller = RefreshController(initialRefresh: true);

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
    final response = await http
        .get(Uri.parse("https://api.coingecko.com/api/v3/coins?per_page=10"));
    setState(() {
      _cryptos = json.decode(response.body);
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
    _cryptos.sort((b, a) => a['market_data']['current_price'][holder]
        .compareTo(b["market_data"]["current_price"][holder]));
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Go back to top'),
        onPressed: () {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn);
          });
        },
        icon: const Icon(Icons.arrow_upward),
      ),
      body: /*SmartRefresher(
        controller: controller,
        onRefresh: () {

        },
        onLoading: () {

        },
        child: */
          ListView.builder(
        controller: _scrollController,
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
                  subtitle: Text(_cryptos[index]['market_data']['current_price']
                              [holder]
                          .toString() +
                      " $currency"),
                  //trailing: const Icon(Icons.favorite),
                )
              ],
            ),
          );
        },
      ),
      //)
    );
  }

  @override
  void initState() {
    super.initState();
    getCryptos();
  }

  String selectedValue = 'usd';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Cryptocurrencies'),
        centerTitle: true,
        actions: <Widget>[
          DropdownButton(
            icon: const Icon(Icons.price_change_sharp),
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
      /*bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          onItemTapped(index);
          switch (index) {
            case 0:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewsPage(),
                  ));
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CryptoPage(),
                  ));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrendingPage(),
                  ));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases_sharp), label: "News Feed"),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: "Cryptocurrencies",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows_outlined), label: "Trendings"),
        ],
      ),*/
    );
  }

/*void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }*/
}

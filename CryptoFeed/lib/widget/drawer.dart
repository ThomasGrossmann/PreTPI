import 'package:flutter/material.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/config/config.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 60,
            child: const DrawerHeader(
              child: Text(
                'Navigation Tab',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ListTile(
            title: const Text('News Feed'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsPage()),
              );
            },
            leading: const Icon(Icons.new_releases_sharp),
          ),
          ListTile(
            title: const Text('Cryptocurrencies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CryptoPage()),
              );
            },
            leading: const Icon(Icons.monetization_on),
          ),
          ListTile(
            title: const Text('My Transactions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransactionsPage()),
              );
            },
            leading: const Icon(Icons.compare_arrows_outlined),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrendingPage()));
            },
            leading: const Icon(Icons.house),
          ),
          Align(
            child: FloatingActionButton.extended(
              onPressed: () {
                currentTheme.switchTheme();
              },
              label: const Text('Light/Dark Mode'),
              icon: const Icon(Icons.brightness_6_outlined),
            ),
          ),
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

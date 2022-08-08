// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: ListView(
        children: <Widget> [
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  '메뉴',
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: SizedBox.shrink(),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
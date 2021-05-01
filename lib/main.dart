import 'package:flutter/material.dart';

import 'package:shopping_list/src/home_page.dart';

void main() => runApp(ShoppingListApp());

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

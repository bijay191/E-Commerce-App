import 'package:flutter/material.dart';
import 'package:shop_app/widgets/cart_widget.dart';

PreferredSize AppBarForShopApp(String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(40),
    child: AppBar(
      shadowColor: const Color.fromARGB(0, 0, 0, 0),
      title: Text(title),
      actions: [],
    ),
  );
}

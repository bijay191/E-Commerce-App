import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/appbar.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '\orderscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBarForShopApp('Your Orders'),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(
              Provider.of<Auth>(context, listen: false).token,
              Provider.of<Auth>(context, listen: false).userId),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error == null) {
                return Consumer<Orders>(builder: ((context, value, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) => OrderItemWidget(
                      order: value.orders[index],
                    ),
                    itemCount: value.orders.length,
                  );
                }));
              }
            }
            return const Center(child: Text('No orders yet'));
          }),
    );
  }
}

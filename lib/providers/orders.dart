import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder(String token,String userId) async {
    var url = Uri.parse(
        'https://sample-7dd07-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, value) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']),
              )
              .toList(),
          dateTime: DateTime.parse(value['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<CartItem> cartProducts, double total, String token,String userId) async {
    final timeStamp = DateTime.now();
    var url = Uri.parse(
        'https://sample-7dd07-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'id': DateTime.now().toString(),
          'amount': total,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
          'dateTime': timeStamp.toIso8601String(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

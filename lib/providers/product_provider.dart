import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token,String userid) async {
    final oldStatus = isFavorite;
    var url = Uri.parse(
        'https://sample-7dd07-default-rtdb.firebaseio.com/userFavorites/$userid/$id.json?auth=$token');
    isFavorite = !isFavorite;
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite
        ),
      );
      if(response.statusCode >=400){
        isFavorite = oldStatus;
      }
    } catch (error) {
      isFavorite = oldStatus;
    }
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exeption.dart';

import '../constant/const.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite = false;
  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
  });
  Future<void> toggleFavoriteStatus(String userId, String token) async {
    final Uri url =
        Uri.parse("$httpLink/usersFavorite/$userId/$id.json?auth=$token");
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        throw HttpExeption(message: "some thing wrong");
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

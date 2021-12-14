import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../constant/const.dart';
import '../models/http_exeption.dart';

class Products with ChangeNotifier {
  final String token;
  final String userId;
  Products(this.token, this.userId, this._products);
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get getProduct {
    return [..._products];
  }

  Product getByID(String id) {
    return _products.firstWhere((element) => (element.id == id));
  }

  List<Product> get getFavoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchData([bool isPersional = false]) async {
    final Uri favUrl =
        Uri.parse("$httpLink/usersFavorite/$userId.json?auth=$token");
    if (!isPersional) {
      final Uri productUrl = Uri.parse("$httpLink/products.json?auth=$token");
      try {
        final responseProducts = await http.get(productUrl);
        final responseFav = await http.get(favUrl);
        final extractProducts =
            json.decode(responseProducts.body) as Map<String, dynamic>;
        final extractFav =
            json.decode(responseFav.body) as Map<String, dynamic>;
        if (extractProducts == null) return;
        _products.clear();
        extractProducts.forEach((key, value) {
          _products.add(Product(
            id: key,
            title: value["title"],
            price: value["price"],
            description: value["description"],
            imageUrl: value["imageUrl"],
          ));
        });
        if (extractFav != null)
          for (int i = 0; i < _products.length; ++i) {
            if (extractFav.containsKey(_products[i].id))
              _products[i].isFavorite = extractFav[_products[i].id];
          }
        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      final Uri url = Uri.parse(
          '$httpLink/products.json?auth=$token&orderBy="creator"&equalTo="$userId"');
      try {
        final response = await http.get(url);
        final extractData = json.decode(response.body) as Map<String, dynamic>;
        print(extractData);
        if (extractData == null) return;
        _products.clear();
        extractData.forEach((key, value) {
          _products.add(Product(
            id: key,
            title: value["title"],
            price: value["price"],
            description: value["description"],
            imageUrl: value["imageUrl"],
          ));
        });
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    if (id != null) {
      final Uri urlPatch = Uri.parse("$httpLink/products/$id.json?auth=$token");
      await http.patch(urlPatch,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'description': product.description,
          }));
      int prodIndex = _products.indexWhere((element) => element.id == id);
      _products[prodIndex] = product;
      notifyListeners();
    } else {
      try {
        final Uri urlPost = Uri.parse("$httpLink/products.json?auth=$token");
        final response = await http.post(
          urlPost,
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "description": product.description,
            "creator": userId,
          }),
        );
        _products.add(Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
        ));
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } //print(json.decode(response.body));
  }

  Future<void> removeProduct(String id) async {
    final Uri url = Uri.parse("$httpLink/products/$id.json?auth=$token");
    if (id != null) {
      final index = _products.indexWhere((element) => (element.id == id));
      final product = _products[index];
      _products.removeWhere((element) => (element.id == id));
      notifyListeners();
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _products.insert(index, product);
        notifyListeners();
        throw (HttpExeption(message: "some thing worng"));
      }
    }
  }
}

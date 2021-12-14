import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';
import '../constant/const.dart';

class Order {
  final DateTime time;
  final List<CartInfo> cart;
  final double amount;
  Order({
    @required this.time,
    @required this.cart,
    @required this.amount,
  });
}

class Orders with ChangeNotifier {
  final String token;
  List<Order> _orders = [];

  Orders(this.token, this._orders);
  List<Order> getOrders() {
    return _orders;
  }

  Future<void> fetchData() async {
    final Uri url = Uri.parse("$httpLink/orders.json?auth=$token");
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData != null) {
        _orders.clear();
        extractData.forEach((key, value) {
          _orders.add(Order(
              time: DateTime.parse(value['time']),
              cart: (value['carts'] as List<dynamic>)
                  .map((e) => CartInfo(
                        idCart: DateTime.parse(e['idCart']),
                        idProduct: e['idProduct'],
                        title: e['title'],
                        price: e['price'],
                        amount: e['amount'],
                      ))
                  .toList(),
              amount: value['amount']));
        });
        notifyListeners();
        print(extractData);
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addOrder(Order order) async {
    final Uri url = Uri.parse("$httpLink/orders.json?auth=$token");
    try {
      await http.post(url,
          body: json.encode({
            "time": order.time.toIso8601String(),
            "carts": order.cart
                .map((e) => {
                      "idCart": e.idCart.toIso8601String(),
                      "idProduct": e.idProduct,
                      "title": e.title,
                      "price": e.price,
                      "amount": e.amount,
                    })
                .toList(),
            "amount": order.amount,
          }));
      _orders.add(order);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

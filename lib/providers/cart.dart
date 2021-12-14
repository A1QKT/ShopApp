import 'package:flutter/material.dart';

class CartInfo {
  final DateTime idCart;
  final String idProduct;
  final String title;
  final double price;
  int amount = 0;
  CartInfo({
    @required this.idCart,
    @required this.idProduct,
    @required this.title,
    @required this.price,
    this.amount,
  }) {
    amount = this.amount;
  }
}

class Cart with ChangeNotifier {
  List<CartInfo> _cartInfos = [];
  String get totalTrasactions {
    return _cartInfos.length.toString();
  }

  List<CartInfo> get getCarts {
    return _cartInfos;
  }

  double get amount {
    double total = 0;
    for (int i = 0; i < _cartInfos.length; ++i) {
      total += _cartInfos[i].amount * _cartInfos[i].price;
    }
    return total;
  }

  void removeTransaction(CartInfo cart) {
    _cartInfos.removeWhere(
        (element) => (element.idCart.toString() == cart.idCart.toString()));
    notifyListeners();
  }

  void addCartInfo(String idProduct, String title, double price) {
    bool isAdded = false;
    for (int i = 0; i < _cartInfos.length; ++i) {
      if (_cartInfos[i].idProduct.toString() == idProduct.toString()) {
        _cartInfos[i].amount++;
        isAdded = true;
        break;
      }
    }
    if (!isAdded) {
      _cartInfos.add(
        CartInfo(
          idCart: DateTime.now(),
          idProduct: idProduct,
          title: title,
          price: price,
          amount: 1,
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _cartInfos.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cartScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
        ],
      ),
      body: Consumer<Cart>(
        builder: (_, cart, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (cart.getCarts.length > 0)
                ? ButtonOrder(
                    carts: cart,
                  )
                : Center(child: Text("There is no order yet")),
            SizedBox(
              height: 8,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: ListView(
                children: cart.getCarts.map((e) => CartItem(cart: e)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOrder extends StatefulWidget {
  final Cart carts;
  ButtonOrder({@required this.carts});
  @override
  _ButtonOrderState createState() => _ButtonOrderState();
}

class _ButtonOrderState extends State<ButtonOrder> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? CircularProgressIndicator()
        : FlatButton(
            onPressed: () async {
              setState(() {
                _isloading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                    Order(
                        cart: widget.carts.getCarts,
                        time: DateTime.now(),
                        amount: widget.carts.amount));
                setState(() {
                  _isloading = false;
                });
                widget.carts.clearCart();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Some thing is wrong!")));
                setState(() {
                  _isloading = false;
                });
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text("ORDER"),
          );
  }
}

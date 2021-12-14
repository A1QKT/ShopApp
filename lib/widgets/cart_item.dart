import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final CartInfo cart;

  CartItem({@required this.cart});
  @override
  Widget build(BuildContext context) {
    Cart carts = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(cart.idCart),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        carts.removeTransaction(cart);
      },
      child: Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cart.title,
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Text(
                  "Amount: ${cart.amount}",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  "Price: ${cart.price * cart.amount}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Text(
              "${DateFormat('yyyy/mm/dd').format(cart.idCart)}",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}

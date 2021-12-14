import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';

class OrderItem extends StatefulWidget {
  final DateTime idOrder;
  final List<CartInfo> carts;
  final double amount;
  OrderItem({
    @required this.idOrder,
    @required this.carts,
    @required this.amount,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat("yyyy/mm/dd").format(widget.idOrder),
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Text(
                "Amount: ${widget.amount}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 4.0,
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon:
                _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          ),
          if (_isExpanded)
            Container(
              alignment: Alignment.center,
              height: 50,
              child: ListView(
                children: widget.carts.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${e.title}:  x${e.amount}"),
                      Spacer(),
                      Text("${e.price}"),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

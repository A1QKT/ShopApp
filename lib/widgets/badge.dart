import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class Badge extends StatelessWidget {
  const Badge({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        child,
        Positioned(
          left: 0,
          top: 4,
          child: Container(
            alignment: Alignment.center,
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Consumer<Cart>(
              builder: (_, cart, chiild) => (cart.totalTrasactions.length > 2)
                  ? Text(
                      cart.totalTrasactions,
                      style: TextStyle(fontSize: 10),
                    )
                  : Text(
                      cart.totalTrasactions,
                      style: TextStyle(fontSize: 20),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

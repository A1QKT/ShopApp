import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/draw.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/order-screen';
//   @override
//   void didChangeDependencies() {
//     if (isLoadingOrderScreen) {
//       Provider.of<Orders>(context, listen: false).fetchData().then((_) {
//         setState(() {
//           isLoadingOrderScreen = false;
//         });
//       }).catchError((error) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Some thing wrong")));
//         setState(() {
//           isLoadingOrderScreen = false;
//         });
//       });
//     }
//     super.didChangeDependencies();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
      ),
      drawer: DrawScreenAsset(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchData(),
          builder: (ctx, dataSnapSot) {
            if (dataSnapSot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapSot.error != null) {
                return Center(
                  child: Text("Something wrong"),
                );
              } else {
                return Consumer<Orders>(
                  builder: (_, orders, child) => Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: orders.getOrders().map((e) {
                          return OrderItem(
                            idOrder: e.time,
                            carts: e.cart,
                            amount: e.amount,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}

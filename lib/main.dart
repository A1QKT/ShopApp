import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/user_screen.dart';

import './providers/cart.dart';
import './providers/products_provider.dart';
import './providers/auth.dart';

import './screens/detail_product_sceen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_screen.dart';
import './screens/auth_screen.dart';
import './screens/order_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(
                Provider.of<Auth>(ctx, listen: false).getToken,
                Provider.of<Auth>(ctx, listen: false).getUserId, []),
            update: (ctx, auth, prod) =>
                Products(auth.getToken, auth.getUserId, prod.getProduct)),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) =>
                Orders(Provider.of<Auth>(ctx, listen: false).getToken, []),
            update: (ctx, auth, orders) =>
                Orders(auth.getToken, orders.getOrders())),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.amber,
          ),
          home: auth.getIsAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.isAutoLogin(),
                  builder: (_, dataSnapsot) =>
                      (dataSnapsot.connectionState == ConnectionState.waiting)
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            DetailProduct.routeName: (ctx) => DetailProduct(),
            CartScreen.routeName: (ctx) => CartScreen(),
            EditScreen.routeName: (ctx) => EditScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
          },
        ),
      ),
    );
  }
}

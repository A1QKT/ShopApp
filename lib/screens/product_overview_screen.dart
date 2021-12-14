import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/screens/draw.dart';
import '../widgets/product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import 'cart_screen.dart';

enum FilterStatus {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static String routeName = "/productOverview-screeen";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Overview"),
          centerTitle: true,
          actions: [
            Badge(child: CartIcon(context: context)),
            PopupMenuButton(
              onSelected: (FilterStatus index) {
                if (index == FilterStatus.All)
                  setState(() {
                    _isFavorite = false;
                  });
                else if (index == FilterStatus.Favorite)
                  setState(() {
                    _isFavorite = true;
                  });
                else
                  return;
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text("Favorite"), value: FilterStatus.Favorite),
                PopupMenuItem(
                    child: Text("Show All Products"), value: FilterStatus.All),
              ],
            ),
          ],
        ),
        drawer: DrawScreenAsset(),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).fetchData(),
          builder: (ctx, dataSnapsot) {
            if (dataSnapsot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (dataSnapsot.error != null)
              return Center(child: Text("Some thing wrong"));
            else
              return Consumer<Products>(
                builder: (ctx, prod, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 2.0,
                    ),
                    itemCount: _isFavorite
                        ? prod.getFavoriteProducts.length
                        : prod.getProduct.length,
                    itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                      value: _isFavorite
                          ? prod.getFavoriteProducts[index]
                          : prod.getProduct[index],
                      child: ProductItem(),
                    ),
                  );
                },
              );
          },
        ));
  }
}

class CartIcon extends StatelessWidget {
  final BuildContext context;
  CartIcon({@required this.context});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
      icon: Icon(
        Icons.shopping_cart,
      ),
    );
  }
}

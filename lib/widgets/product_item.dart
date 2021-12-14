import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/screens/detail_product_sceen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(DetailProduct.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () {
              product.toggleFavoriteStatus(
                Provider.of<Auth>(context, listen: false).getUserId,
                Provider.of<Auth>(context, listen: false).getToken,
              );
            },
            icon: product.isFavorite
                ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
          ),
          title: Text(
            "${product.title}",
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, child) => IconButton(
              onPressed: () {
                cart.addCartInfo(product.id, product.title, product.price);
              },
              icon: Icon(
                Icons.shopping_bag,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

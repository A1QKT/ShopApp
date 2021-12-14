import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class DetailProduct extends StatelessWidget {
  static String routeName = "/detail-product";
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).getByID(id);
    return Scaffold(
      appBar: AppBar(
        title: Text("${product.title}"),
      ),
      body: Container(),
    );
  }
}

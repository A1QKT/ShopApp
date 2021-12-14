import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../screens/edit_screen.dart';

class UserItem extends StatelessWidget {
  final String vendor;
  UserItem({@required this.vendor});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Consumer<Product>(
        builder: (_, prod, child) => Container(
          alignment: Alignment.center,
          child: ListTile(
            leading: Container(
              height: 40,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prod.title,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "Price: ${prod.price}",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            title: Container(
              child: Column(
                children: [
                  Text(
                    "Vendor",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    vendor,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(EditScreen.routeName, arguments: prod.id);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[500],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .removeProduct(prod.id);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Some thing Wrong!")));
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

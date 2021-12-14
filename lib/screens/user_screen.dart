import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_item.dart';
import 'edit_screen.dart';
import 'draw.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/user-screen";
  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // final scaffold = ScaffoldMessenger.of(context);
    return RefreshIndicator(
      onRefresh: () {
        return _refreshData(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Products"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditScreen.routeName,
                );
              },
              icon: Icon(
                Icons.add,
              ),
            )
          ],
        ),
        drawer: DrawScreenAsset(),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).fetchData(true),
          builder: (ctx, dataSnapSot) {
            if (dataSnapSot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (dataSnapSot.error != null) {
              // scaffold
              //     .showSnackBar(SnackBar(content: Text("Some thing wrong")));
              return Center(
                child: Text("Some thing wrong"),
              );
            }
            return Container(
              child: Consumer<Products>(
                builder: (_, prods, child) => ListView(
                  children: prods.getProduct
                      .map((e) => ChangeNotifierProvider.value(
                            value: e,
                            child: UserItem(
                              vendor: "UserName",
                            ),
                          ))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

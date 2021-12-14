import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_overview_screen.dart';
import 'order_screen.dart';
import 'user_screen.dart';
import '../providers/auth.dart';

class DrawScreenAsset extends StatelessWidget {
  Widget featureDrawer(
      {@required String text,
      @required String routeName,
      @required BuildContext context,
      @required MediaQueryData queryData}) {
    return FlatButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12),
          ),
        ),
        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        width: queryData.size.width,
        height: queryData.size.height / 10,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: queryData.size.width,
            height: queryData.size.height / 6,
            alignment: Alignment.centerLeft,
            child: Text(
              "Shop App",
              style: TextStyle(
                fontSize: 48,
                color: Color(0xFFDF1010),
              ),
            ),
          ),
          featureDrawer(
            text: "Your Orders",
            routeName: OrderScreen.routeName,
            context: context,
            queryData: queryData,
          ),
          featureDrawer(
            text: "Your Products",
            routeName: UserProductScreen.routeName,
            context: context,
            queryData: queryData,
          ),
          featureDrawer(
            text: "Go Shopping",
            routeName: ProductOverviewScreen.routeName,
            context: context,
            queryData: queryData,
          ),
          FlatButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              width: 318,
              height: 80,
              alignment: Alignment.centerLeft,
              child: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

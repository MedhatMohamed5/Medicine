import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/screens/add_screens/add_customer.dart';
import 'package:dr_ahmed_medicine/screens/add_screens/add_product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/nav_route.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_invoices.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_order.dart';

class MenuDrawer extends StatelessWidget {
  final List<NavRoute> routes = [
    NavRoute(
      "Add New Medicine",
      () => AddProduct(),
    ),
    NavRoute(
      "Add Customer",
      () => AddCustomer(),
    ),
    NavRoute(
      "Sales Orders",
      () => OrdersScreen(),
    ),
    NavRoute(
      "Invoices",
      () => InvoicesScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: ListView.builder(
          itemCount: routes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  routes[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => routes[index].route()));
                /*Navigator.push(context, routes[index].route);
                Navigator.pop(context);*/
              },
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.chevron_right),
              ),
            );
          }),
    );
  }
}

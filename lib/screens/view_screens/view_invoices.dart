import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/customer/customer.dart';
import 'package:dr_ahmed_medicine/order/order.dart';
import 'package:dr_ahmed_medicine/order/order_item.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_single_invoice.dart';

class InvoicesScreen extends StatefulWidget {
  @override
  _InvoicesScreenState createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoices',
        ),
      ),
      body: _drawInvoices(),
    );
  }

  Widget _drawInvoices() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(Order.kEntity)
          .where(Order.kIsInvoiced, isEqualTo: true)
          .orderBy(Order.kOrderNumber)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(
              'Error : ${snapshot.error}',
            ),
          );

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(
                'There is no invoiced orders',
              ),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: Loading(
                Colors.red,
                Colors.blue,
                Colors.yellow,
              ),
            );
            break;
          default:
            if (snapshot.data.documents.length == 0)
              return Center(
                child: Text(
                  'There is no invoiced orders',
                ),
              );
            List<Order> orders = [];
            for (var data in snapshot.data.documents) {
              var order = data.data;
              //print(order[Order.kCustomer].toString());
              orders.add(
                Order(
                  id: data.documentID,
                  orderNumber: order[Order.kOrderNumber] != null
                      ? order[Order.kOrderNumber]
                      : 0,
                  modifiedDate: order[Order.kModifiedDate],
                  customer: order[Order.kCustomer] != null
                      ? Customer.fromJson(order[Order.kCustomer])
                      : Customer(),
                  orderItems: order[Order.kOrderItems] != null
                      ? OrderItem.toItemsList(order[Order.kOrderItems])
                      : [],
                  paidAmount: order[Order.kPaidAmount] != null
                      ? order[Order.kPaidAmount]
                      : 0.0,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SingleInvoice(orders[index].id, orders[index]),
                        ),
                      );
                    },
                    splashColor: Colors.blue[100],
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Order - ${orders[index].orderNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          'Customer: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          '${orders[index].customer.name}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Total: ${orders[index].getTotalAmount()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Paid: ${orders[index].paidAmount}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: orders.length,
              ),
            );
            break;
        }
      },
    );
  }
}

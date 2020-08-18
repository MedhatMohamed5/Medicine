//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/customer/customer.dart';
import 'package:dr_ahmed_medicine/order/order.dart';
import 'package:dr_ahmed_medicine/order/order_item.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_single_order.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  var selectedCustomerId;
  Customer selectedCustomer;
  bool canSubmit = false, isLoading = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add New Order'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _addOrder,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Loading(
                Colors.red,
                Colors.blue,
                Colors.yellow,
              ),
            )
          : Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Please choose a customer:',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection(Customer.kEntity)
                          .orderBy(Customer.kName)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Text(
                            'There is an error, please try again later!',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        if (!snapshot.hasData)
                          return Text(
                            'There is no customers defined to be selected!',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          );

                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text(
                              'There is no customers defined to be selected!',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
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
                            List<DropdownMenuItem> customerItems = [];
                            List<Customer> customers = [];
                            for (var doc in snapshot.data.documents) {
                              var customer = doc.data;
                              customerItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    customer[Customer.kName],
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 20),
                                  ),
                                  value: doc.documentID,
                                ),
                              );
                              customers.add(
                                Customer(
                                  id: doc.documentID,
                                  name: customer[Customer.kName],
                                  phone: customer[Customer.kPhone],
                                ),
                              );
                            }
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.blue,
                                  ),
                                ),
                                child: DropdownButton(
                                  items: customerItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCustomerId = value;
                                      selectedCustomer = customers
                                          .where((element) =>
                                              element.id == selectedCustomerId)
                                          .first;
                                      print(selectedCustomerId +
                                          ' ' +
                                          selectedCustomer.name);
                                      canSubmit = true;
                                    });
                                  },
                                  value: selectedCustomerId,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  hint: Text(
                                    'Choose Customer',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 20),
                                  ),
                                  iconEnabledColor: Colors.blue,
                                  elevation: 1,
                                  focusColor: Colors.blue,
                                ),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _addOrder() async {
    print('Get In');
    if (canSubmit) {
      setState(() {
        isLoading = true;
      });
      int lastOrderNumber = 0;

      await Firestore.instance
          .collection(Order.kEntity)
          .getDocuments()
          .then((value) {
        if (value != null) {
          lastOrderNumber = value.documents.length;
        }
      });

      await Firestore.instance.collection(Order.kEntity).document().setData(
        {
          Order.kCustomer: selectedCustomer.toJson(),
          Order.kModifiedDate: DateTime.now(),
          Order.kOrderNumber: lastOrderNumber + 1,
          Order.kOrderItems: [],
          Order.kIsInvoiced: false,
          Order.kPaidAmount: 0.0,
        },
      );

      Order passOrder;
      await Firestore.instance
          .collection(Order.kEntity)
          .where(Order.kOrderNumber, isEqualTo: lastOrderNumber + 1)
          .getDocuments()
          .then((value) {
        if (value != null) {
          var order = value.documents.first.data;
          passOrder = Order(
            id: value.documents.first.documentID,
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
          );
        }
      });

      /*setState(() {
        isLoading = false;
      });*/
//      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SingleOrderScreen(passOrder.id, passOrder),
        ),
      );
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please choose a customer'),
        ),
      );
    }
  }
}

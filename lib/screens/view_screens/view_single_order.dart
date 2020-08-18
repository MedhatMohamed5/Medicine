import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/order/order.dart';
import 'package:dr_ahmed_medicine/order/order_item.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/add_screens/add_order_item.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';
import 'package:dr_ahmed_medicine/screens/edit_screens/submit_order.dart';

class SingleOrderScreen extends StatefulWidget {
  final String orderId;
  final Order order;

  SingleOrderScreen(this.orderId, this.order);

  @override
  _SingleOrderScreenState createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  bool isLoading = false;
  List<OrderItem> _orderItems = [];
  num total = 0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Order ${widget.order.orderNumber} - ${widget.order.customer.name}',
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SUBMIT',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (total > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SubmitOrder(
                      widget.orderId,
                      widget.order,
                      total,
                    );
                  }),
                );
              } else {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: _orderItems.length > 0
                        ? Text('Cannot submit order with total 0')
                        : Text('There is no items to be submitted'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrderItem(
                widget.orderId,
                _orderItems.length + 1,
                _orderItems,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add order item',
      ),
      body: _drawOrderItems(),
    );
  }

  Widget _drawOrderItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(OrderItem.kEntity)
          .where(OrderItem.kOrderId, isEqualTo: widget.orderId)
          .orderBy(OrderItem.kLineNumber)
          .snapshots(),
      builder: (context, snapshot) {
        List<OrderItem> orderItems = [];
        if (snapshot.hasError)
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        if (!snapshot.hasData)
          return Center(
            child: Text(
              'There is no order items',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          );
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(
                'There is no order items',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: Loading(
                Colors.blue,
                Colors.red,
                Colors.yellow,
              ),
            );
            break;
          default:
            total = 0;
            for (var data in snapshot.data.documents) {
              var orderItem = data.data;
              orderItems.add(
                OrderItem(
                  id: data.documentID,
                  lineNumber: orderItem[OrderItem.kLineNumber],
                  orderId: orderItem[OrderItem.kOrderId],
                  qty: orderItem[OrderItem.kQty],
                  unitDiscount: orderItem[OrderItem.kUnitDiscount],
                  unitPrice: orderItem[OrderItem.kUnitPrice],
                  product: Product.fromJson(orderItem[OrderItem.kProduct]),
                ),
              );
            }
            _orderItems = [...orderItems];
            _orderItems.forEach((element) {
              total += element.totalAmount();
            });
            if (orderItems.length == 0)
              return Center(
                child: Text(
                  'There is no order items',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              );
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          total.toString(),
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  orderItems[index].lineNumber.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      orderItems[index].product.name,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Unit Price: ${orderItems[index].unitPrice}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Quantity: ${orderItems[index].qty}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Unit Discount: ${orderItems[index].unitDiscount}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Total Amount: ${orderItems[index].totalAmount()}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  color: Colors.red,
                                  onPressed: () => _deleteLine(
                                      orderItems[index].lineNumber,
                                      orderItems[index].id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: orderItems.length,
                  ),
                ),
              ],
            );
            break;
        }
        //return Container();
      },
    );
  }

  _deleteLine(num lineNumber, String documentId) async {
    setState(() {
      isLoading = true;
    });
    print(lineNumber.toString() + ' ' + documentId);

    _orderItems.removeAt(lineNumber - 1);

    _orderItems.forEach((element) {
      if (element.lineNumber > lineNumber) {
        element.lineNumber--;
      }
    });

    List<OrderItem> passToOrder = [..._orderItems];

    await Firestore.instance
        .collection(OrderItem.kEntity)
        .document(documentId)
        .delete();

    await Firestore.instance
        .collection(OrderItem.kEntity)
        .where(OrderItem.kLineNumber, isGreaterThan: lineNumber)
        .where(OrderItem.kOrderId, isEqualTo: widget.orderId)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          element.reference.updateData(
              {OrderItem.kLineNumber: element.data[OrderItem.kLineNumber] - 1});
        });
      }
    });

    await Firestore.instance
        .collection(Order.kEntity)
        .document(widget.orderId)
        .updateData({
      Order.kOrderItems: Order.itemsToJson(passToOrder),
      Order.kModifiedDate: Timestamp.now(),
    });

    setState(() {
      isLoading = false;
    });
  }
}

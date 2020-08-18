import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/customer/customer.dart';
import 'package:dr_ahmed_medicine/order/order.dart';
import 'package:dr_ahmed_medicine/order/order_item.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

class SubmitOrder extends StatefulWidget {
  final String orderId;
  final num total;
  final Order order;

  SubmitOrder(this.orderId, this.order, this.total);

  @override
  _SubmitOrderState createState() => _SubmitOrderState();
}

class _SubmitOrderState extends State<SubmitOrder> {
  bool isLoading = false, isSubmitted = false;
  TextEditingController paidController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    paidController.text = widget.total.toString();
  }

  @override
  void dispose() {
    super.dispose();
    paidController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSubmitted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order ${widget.order.orderNumber} - Submission',
          ),
          actions: <Widget>[
            IconButton(
              onPressed: _submitOrder,
              icon: Icon(Icons.done),
            ),
          ],
        ),
        body: !isLoading
            ? !isSubmitted ? _amountsView() : _afterSubmission()
            : Center(
                child: Loading(
                  Colors.red,
                  Colors.blue,
                  Colors.yellow,
                ),
              ),
      ),
    );
  }

  Widget _amountsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Total: ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      widget.total.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: paidController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration.copyWith(
                  labelText: 'To be Paid',
                  hintText: 'To be Paid',
                ),
                validator: (value) {
                  if (value.length == 0)
                    return 'Please enter amount to be paid';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _afterSubmission() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Order is submitted!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text(
              'Back to orders list',
              style: TextStyle(color: Colors.white, letterSpacing: 1.5),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _submitOrder() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await Firestore.instance
          .collection(OrderItem.kEntity)
          .where(OrderItem.kOrderId, isEqualTo: widget.orderId)
          .getDocuments()
          .then((value) {
        if (value != null) {
          for (var orderItem in value.documents) {
            var item = orderItem.data;
            Product product = Product.fromJson(item[OrderItem.kProduct]);
            print('submit ' + product.id);
            Firestore.instance
                .collection(Product.kEntity)
                .document(product.id)
                .updateData({
              Product.kAvailableQty:
                  FieldValue.increment(-1 * item[OrderItem.kQty]),
              Product.kModifiedTime: Timestamp.now(),
            });
          }
        }
      });

      await Firestore.instance
          .collection(Customer.kEntity)
          .where(Customer.kPhone, isEqualTo: widget.order.customer.phone)
          .getDocuments()
          .then((value) {
        if (value != null) {
          Firestore.instance
              .collection(Customer.kEntity)
              .document(value.documents.first.documentID)
              .updateData({
            Customer.kTotalPaidAmount:
                FieldValue.increment(double.parse(paidController.text)),
            Customer.kTotalInvoiceAmount: FieldValue.increment(widget.total),
          });
        }
      });

      await Firestore.instance
          .collection(Order.kEntity)
          .document(widget.orderId)
          .updateData({
        Order.kIsInvoiced: true,
        Order.kModifiedDate: Timestamp.now(),
        Order.kPaidAmount: double.parse(paidController.text),
      });

      setState(() {
        isSubmitted = true;
        isLoading = false;
      });
    }
  }
}

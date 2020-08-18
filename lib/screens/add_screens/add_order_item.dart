import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/order/order.dart';
import 'package:dr_ahmed_medicine/order/order_item.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

// ignore: must_be_immutable
class AddOrderItem extends StatefulWidget {
  final String orderId;
  final int lineNumber;
  List<OrderItem> orderItemsList;

  AddOrderItem(this.orderId, this.lineNumber, this.orderItemsList);

  @override
  _AddOrderItemState createState() => _AddOrderItemState();
}

class _AddOrderItemState extends State<AddOrderItem> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool canSubmit;
  var selectedProductId;
  Product selectedProduct;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  TextEditingController unitPriceController = TextEditingController();
  TextEditingController listPriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController unitDiscountController = TextEditingController();

  @override
  void dispose() {
    unitPriceController.dispose();
    listPriceController.dispose();
    qtyController.dispose();
    unitDiscountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add order line ${widget.lineNumber}',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _addItem,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Loading(
                Colors.blue,
                Colors.red,
                Colors.yellow,
              ),
            )
          : _drawAddForm(),
    );
  }

  Widget _drawAddForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  child: selectedProduct != null
                      ? selectedProduct.imageUrl.length != 0
                          ? CachedNetworkImage(
                              imageUrl: selectedProduct.imageUrl,
                              height: 150,
                              width: 150,
                            )
                          /*Image.network(
                              selectedProduct.imageUrl,
                              height: 150,
                              width: 150,
                            )*/
                          : Container(
                              height: 150,
                              width: 150,
                              child: Image.asset(
                                'assets/images/medicine_icon.png',
                              ),
                            )
                      : Container(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            'assets/images/medicine_icon.png',
                          ),
                        ),
                ),
                SizedBox(
                  height: 16,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(Product.kEntity)
                      .orderBy(Product.kName)
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

                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text(
                          'There is no medicines defined to be selected!',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                        break;
                      /*case ConnectionState.waiting:
                        return Center(
                          child: Loading(
                            Colors.red,
                            Colors.blue,
                            Colors.yellow,
                          ),
                        );
                        break;*/
                      default:
                        if (!snapshot.hasData)
                          return Text(
                            'There is no medicines defined to be selected!',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        List<DropdownMenuItem> productItems = [];
                        List<Product> products = [];
                        for (var doc in snapshot.data.documents) {
                          var product = doc.data;
                          productItems.add(
                            DropdownMenuItem(
                              child: Text(
                                product[Product.kName],
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              ),
                              value: doc.documentID,
                            ),
                          );
                          products.add(
                            Product(
                              id: doc.documentID,
                              name: product[Product.kName] != null
                                  ? product[Product.kName]
                                  : "",
                              price: product[Product.kPrice] != null
                                  ? product[Product.kPrice]
                                  : 0.0,
                              listPrice: product[Product.kListPrice] != null
                                  ? product[Product.kListPrice]
                                  : 0.0,
                              availableQty:
                                  product[Product.kAvailableQty] != null
                                      ? product[Product.kAvailableQty]
                                      : 0.0,
                              imageUrl: product[Product.kImageURL] != null
                                  ? product[Product.kImageURL]
                                  : "",
                              description: product[Product.kDesc] != null
                                  ? product[Product.kDesc]
                                  : "",
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
                              items: productItems,
                              onChanged: (value) {
                                setState(() {
                                  selectedProductId = value;
                                  selectedProduct = products
                                      .where((element) =>
                                          element.id == selectedProductId)
                                      .first;
                                  print(selectedProductId +
                                      ' ' +
                                      selectedProduct.name);

                                  listPriceController.text =
                                      selectedProduct.listPrice.toString();

                                  unitPriceController.text =
                                      selectedProduct.price.toString();

                                  qtyController.text = "1.0";
                                  unitDiscountController.text = "0.0";

                                  canSubmit = true;
                                });
                              },
                              value: selectedProductId,
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Text(
                                'Choose Medicine',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                                overflow: TextOverflow.ellipsis,
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
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    controller: listPriceController,
                    decoration: inputDecoration.copyWith(
                      hintText: 'List Price',
                      labelText: 'List Price',
                    ),
                    validator: (value) {
                      if (value.length == 0)
                        return 'Please choose a medicine to validate the inputs';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: unitPriceController,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Unit Consumer Price',
                      labelText: 'Unit Consumer Price',
                    ),
                    validator: (value) {
                      if (value.length == 0)
                        return 'Please choose a medicine to validate the inputs';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: unitDiscountController,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Unit Discount',
                      labelText: 'Unit Discount',
                    ),
                    validator: (value) {
                      if (value.length == 0)
                        return selectedProduct == null
                            ? 'Please choose a medicine to validate the inputs'
                            : 'Please enter discount';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: qtyController,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Quantity',
                      labelText: 'Quantity',
                    ),
                    validator: (value) {
                      if (value.length == 0)
                        return selectedProduct == null
                            ? 'Please choose a medicine to validate the inputs'
                            : 'Please enter quantity';
                      if (selectedProduct != null) {
                        if (double.parse(value) > selectedProduct.availableQty)
                          return 'Only available quantity is: ${selectedProduct.availableQty}';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addItem() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await Firestore.instance
          .collection(OrderItem.kEntity)
          .document()
          .setData({
        OrderItem.kOrderId: widget.orderId,
        OrderItem.kProduct: selectedProduct.toJson(),
        OrderItem.kUnitPrice: double.parse(unitPriceController.text),
        OrderItem.kUnitDiscount: double.parse(unitDiscountController.text),
        OrderItem.kQty: double.parse(qtyController.text),
        OrderItem.kLineNumber: widget.lineNumber,
      });

      print('selected : ' + selectedProduct.id);

      OrderItem passedOrder = OrderItem(
        product: selectedProduct,
        unitPrice: double.parse(unitPriceController.text),
        unitDiscount: double.parse(unitDiscountController.text),
        lineNumber: widget.lineNumber,
        qty: double.parse(qtyController.text),
        orderId: widget.orderId,
      );

      widget.orderItemsList.add(passedOrder);

      await Firestore.instance
          .collection(Order.kEntity)
          .document(widget.orderId)
          .updateData({
        Order.kOrderItems: Order.itemsToJson(widget.orderItemsList),
        Order.kModifiedDate: Timestamp.now(),
      });

      Navigator.pop(context);
      /*setState(() {
        isLoading = false;
      });*/
    }
  }
}

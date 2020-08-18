import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';
import 'package:dr_ahmed_medicine/screens/edit_screens/product_edit.dart';

class SingleProductScreen extends StatefulWidget {
  final Product product;

  SingleProductScreen(this.product);

  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  Product _viewProduct;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection(Product.kEntity)
          .document(widget.product.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: new Text(
                'Error: ${snapshot.error}',
              ),
            ),
          );

        if (!snapshot.hasData)
          return Scaffold(
            appBar: AppBar(
              title: Text('No Data'),
            ),
            body: Center(
              child: new Text(
                'There is no data',
              ),
            ),
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading'),
              ),
              body: Center(
                child: Loading(
                  Colors.yellow,
                  Colors.red,
                  Colors.blue,
                ),
              ),
            );
          case ConnectionState.none:
            return Scaffold(
              appBar: AppBar(
                title: Text('No Data'),
              ),
              body: Center(
                child: new Text(
                  'There is no data',
                ),
              ),
            );
          default:
            if (!snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('No Data'),
                ),
                body: Center(
                  child: new Text(
                    'There is no data',
                  ),
                ),
              );
            } else {
              var viewProduct = snapshot.data;
              _viewProduct = Product(
                id: viewProduct.documentID,
                name: viewProduct[Product.kName] != null
                    ? viewProduct[Product.kName]
                    : "",
                availableQty: viewProduct[Product.kAvailableQty] != null
                    ? viewProduct[Product.kAvailableQty]
                    : 0.0,
                soldAmount: viewProduct[Product.kSoldAmount] != null
                    ? viewProduct[Product.kSoldAmount]
                    : 0.0,
                soldQuantity: viewProduct[Product.kSoldQty] != null
                    ? viewProduct[Product.kSoldQty]
                    : 0.0,
                description: viewProduct[Product.kDesc] != null
                    ? viewProduct[Product.kDesc]
                    : "",
                imageUrl: viewProduct[Product.kImageURL] != null
                    ? viewProduct[Product.kImageURL]
                    : "",
                listPrice: viewProduct[Product.kListPrice] != null
                    ? viewProduct[Product.kListPrice]
                    : 0.0,
                modifiedDate: viewProduct[Product.kModifiedTime],
                price: viewProduct[Product.kPrice] != null
                    ? viewProduct[Product.kPrice]
                    : 0.0,
              );
              print(snapshot.data.documentID);
              return Scaffold(
                appBar: AppBar(
                  title: Text(_viewProduct.name),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductEdit(_viewProduct),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (_viewProduct.imageUrl
                                                  .toString()
                                                  .length !=
                                              0 &&
                                          _viewProduct.imageUrl != null)
                                      ? CachedNetworkImageProvider(
                                          _viewProduct.imageUrl,
                                          scale: .5)
                                      : AssetImage(
                                          'assets/images/medicine_icon.png',
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: Text(
                              _viewProduct.name,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            _viewProduct.description.length != 0
                                ? _viewProduct.description
                                : _viewProduct.name,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'List Price: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  _viewProduct.listPrice.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Consumer Price: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  _viewProduct.price.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Available Qty: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: _viewProduct.availableQty > 4
                                        ? Colors.black
                                        : Colors.red,
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  _viewProduct.availableQty.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _viewProduct.availableQty > 4
                                        ? Colors.black
                                        : Colors.red,
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Sold Amount: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  _viewProduct.soldAmount.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Sold Quantity: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  _viewProduct.soldQuantity.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            break;
        }
      },
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductEdit(widget.product),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            (widget.product.imageUrl.toString().length != 0 &&
                                    widget.product.imageUrl != null)
                                ? CachedNetworkImageProvider(
                                    widget.product.imageUrl,
                                    scale: .5)
                                : AssetImage(
                                    'assets/images/medicine_icon.png',
                                  ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    widget.product.name,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.product.description.length != 0
                      ? widget.product.description
                      : widget.product.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'List Price: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.listPrice.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Consumer Price: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.price.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Available Qty: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: widget.product.availableQty > 4
                              ? Colors.black
                              : Colors.red,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.availableQty.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.product.availableQty > 4
                              ? Colors.black
                              : Colors.red,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Sold Amount: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.soldAmount.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Sold Quantity: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.soldQuantity.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}

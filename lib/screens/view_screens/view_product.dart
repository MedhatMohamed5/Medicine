//import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/circle_image.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

//import 'package:dr_ahmed_medicine/screens/customizations/menu_drawer.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_single_product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
//  List<Product> _products;

  @override
  Widget build(BuildContext context) {
    return _drawProducts();
    /*Scaffold(
      drawer: Drawer(
        child: MenuDrawer(),
      ),
      appBar: AppBar(
        title: Text('Medicines'),
      ),
      body: _drawProducts(),
    );*/
  }

  Widget _drawProducts() {
    double circleSize = MediaQuery.of(context).size.width * .15;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(Product.kEntity)
          .orderBy(Product.kName)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            if (snapshot.data.documents.length == 0) {
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
              List<Product> products = [];
              for (var data in snapshot.data.documents) {
                var product = data.data;

                products.add(
                  Product(
                    id: data.documentID,
                    name: product[Product.kName] != null
                        ? product[Product.kName]
                        : "",
                    availableQty: product[Product.kAvailableQty] != null
                        ? product[Product.kAvailableQty]
                        : 0.0,
                    soldAmount: product[Product.kSoldAmount] != null
                        ? product[Product.kSoldAmount]
                        : 0.0,
                    soldQuantity: product[Product.kSoldQty] != null
                        ? product[Product.kSoldQty]
                        : 0.0,
                    description: product[Product.kDesc] != null
                        ? product[Product.kDesc]
                        : "",
                    imageUrl: product[Product.kImageURL] != null
                        ? product[Product.kImageURL]
                        : "",
                    listPrice: product[Product.kListPrice] != null
                        ? product[Product.kListPrice]
                        : 0.0,
                    modifiedDate: product[Product.kModifiedTime],
                    price: product[Product.kPrice] != null
                        ? product[Product.kPrice]
                        : 0.0,
                  ),
                );
              }
//              _products = [...products];

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            /*print(products[index].name +
                                " " +
                                products[index].id);*/
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleProductScreen(products[index]),
                              ),
                            );
                          },
                          splashColor: Colors.blue[100],
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleImage(
                                    size: circleSize,
                                    image: (products[index]
                                                    .imageUrl
                                                    .toString()
                                                    .length !=
                                                0 &&
                                            products[index].imageUrl != null)
                                        ? CachedNetworkImageProvider(
                                            products[index].imageUrl,
                                            scale: .5)
                                        : AssetImage(
                                            'assets/images/medicine_icon.png',
                                          ), //AssetImage('images/A.png'),
                                  ),
                                  /*CircleAvatar(
                              maxRadius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: (document[Product.kImageURL]
                                              .toString()
                                              .length !=
                                          0 &&
                                      document[Product.kImageURL] != null)
                                  ? NetworkImage(
                                      document[Product.kImageURL],
                                      scale: .5,
                                    )
                                  : AssetImage(
                                      'assets/images/medicine_icon.png'),
                            ),*/
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          products[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Price: ${products[index].price}',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 18.0),
                                              ),
                                              Text(
                                                'Available: ${products[index].availableQty}',
                                                style: TextStyle(
                                                    color: products[index]
                                                                .availableQty >
                                                            4
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.redAccent,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  /*ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return InkWell(
                    onTap: () {},
                    splashColor: Colors.blue[100],
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleImage(
                              size: circleSize,
                              image: (document[Product.kImageURL]
                                              .toString()
                                              .length !=
                                          0 &&
                                      document[Product.kImageURL] != null)
                                  ? CachedNetworkImageProvider(
                                      document[Product.kImageURL],
                                      scale: .5)
                                  : AssetImage(
                                      'assets/images/medicine_icon.png',
                                    ), //AssetImage('images/A.png'),
                            ),
                            /*CircleAvatar(
                              maxRadius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: (document[Product.kImageURL]
                                              .toString()
                                              .length !=
                                          0 &&
                                      document[Product.kImageURL] != null)
                                  ? NetworkImage(
                                      document[Product.kImageURL],
                                      scale: .5,
                                    )
                                  : AssetImage(
                                      'assets/images/medicine_icon.png'),
                            ),*/
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document[Product.kName],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Price: ${document[Product.kPrice]}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 18.0),
                                        ),
                                        Text(
                                          'Available: ${document[Product.kAvailableQty]}',
                                          style: TextStyle(
                                              color: document[Product
                                                          .kAvailableQty] >
                                                      4
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.redAccent,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  /*ListTile(
                    title: Text(document[Product.kName]),
                    subtitle: Text(document[Product.kPrice].toString()),
                    trailing: (document[Product.kImageURL].toString().length !=
                                0 &&
                            document[Product.kImageURL] != null)
                        ? SizedBox(
                            width: 150,
                            height: 150,
                            child: Image(
                              image: NetworkImage(document[Product.kImageURL]),
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                  );*/
                }).toList(),
              ),*/
                  );
            }
        }
      },
    );
  }
}

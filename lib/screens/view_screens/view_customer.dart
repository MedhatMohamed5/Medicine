import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/customer/customer.dart';
//import 'package:dr_ahmed_medicine/screens/customizations/circle_image.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return _drawCustomers();
  }

  Widget _drawCustomers() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(Customer.kEntity)
          .orderBy(Customer.kName)
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
            if (snapshot.data.documents.length == 0)
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
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
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          document[Customer.kName],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          document[Customer.kPhone],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Purchased: ',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18.0),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Paid: ',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Balance: ',
                                            style: TextStyle(
                                                color: (document[Customer
                                                                .kTotalPaidAmount] -
                                                            document[Customer
                                                                .kTotalInvoiceAmount]) >=
                                                        0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.redAccent,
                                                fontSize: 18.0),
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            '${document[Customer.kTotalInvoiceAmount]}',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18.0),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              '${document[Customer.kTotalPaidAmount]}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${document[Customer.kTotalPaidAmount] - document[Customer.kTotalInvoiceAmount]}',
                                            style: TextStyle(
                                                color: (document[Customer
                                                                .kTotalPaidAmount] -
                                                            document[Customer
                                                                .kTotalInvoiceAmount]) >=
                                                        0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.redAccent,
                                                fontSize: 18.0),
                                          ),
                                          flex: 1,
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
              ),
            );
        }
      },
    );
  }
}

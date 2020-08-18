import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/customer/customer.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  bool _isLoading = false, _done = false, _addedBefore = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  RegExp phoneReg = RegExp(r'^01[0-9]{9}$');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _isLoading || _done
            ? <Widget>[]
            : <Widget>[
                IconButton(
                  onPressed: _add,
                  icon: Icon(Icons.done),
                ),
              ],
        title: Text('Add Customer'),
      ),
      body: _isLoading
          ? Center(
              child: Loading(
                Colors.blue,
                Colors.red,
                Colors.yellow,
              ),
            )
          : _customerAdd(),
    );
  }

  Widget _customerAdd() {
    return _done
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _addedBefore
                      ? 'Customer is added before!'
                      : 'Customer is added successfully!',
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
                    'Add another',
                    style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _done = false;
                      _addedBefore = false;
                    });
                  },
                )
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            inputDecoration.copyWith(hintText: 'Customer Name'),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter name';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Customer Phone'),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Enter phone';
                          else if (!phoneReg.hasMatch(value)) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _add() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Firestore.instance
          .collection(Customer.kEntity)
          .where(Customer.kPhone, isEqualTo: phoneController.text)
          .getDocuments()
          .then((value) {
        if (value.documents.length == 0) {
          Firestore.instance.collection(Customer.kEntity).document().setData({
            Customer.kName: nameController.text,
            Customer.kPhone: phoneController.text,
            Customer.kTotalInvoiceAmount: 0.0,
            Customer.kTotalPaidAmount: 0.0,
          }).then((value) {
            setState(() {
              _isLoading = false;
              _done = true;
              nameController.clear();
              phoneController.clear();
            });
          });
        } else {
          setState(() {
            _isLoading = false;
            _done = true;
            _addedBefore = true;
          });
        }
      });
    }
  }
}

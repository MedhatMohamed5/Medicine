import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

class ProductEdit extends StatefulWidget {
  final Product product;

  ProductEdit(this.product);

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  bool _isLoading = false, _done = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController listPriceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File _image; //, _image2, _image3;
  ImagePicker _picker = ImagePicker();
  Image image;

  @override
  void initState() {
    nameController.text = widget.product.name;
    descController.text = widget.product.description;
    //qtyController.text = widget.product.availableQty.toString();
    listPriceController.text = widget.product.listPrice.toString();
    priceController.text = widget.product.price.toString();
    image = widget.product.imageUrl.length != 0
        ? Image.network(widget.product.imageUrl)
        : null;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    qtyController.dispose();
    listPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _isLoading || _done
            ? <Widget>[]
            : <Widget>[
                IconButton(
                  onPressed: _edit,
                  icon: Icon(Icons.done),
                ),
              ],
        title: Text('Edit - ' + widget.product.name),
      ),
      body: _isLoading
          ? Center(
              child: Loading(
                Colors.blue,
                Colors.red,
                Colors.yellow,
              ),
            )
          : _medicineEdit(),
    );
  }

  Widget _medicineEdit() {
    return _done
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Medicine is edited successfully!',
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
                    'Back',
                    style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _done = false;
                      Navigator.pop(context);
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
                        enabled: false,
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Medicine Name', labelText: 'Name'),
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
                        controller: descController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Medicine Description',
                            labelText: 'Description'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: TextFormField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Medicine New Quantity',
                            labelText: 'New Quantity'),
//                    decoration: InputDecoration(
//                      enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(8)),
//                          borderSide: BorderSide(color: Colors.grey[200])),
//                      focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(8)),
//                          borderSide: BorderSide(color: Colors.grey[300])),
//                      hintText: 'Medicine Quantity',
//                    ),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter new quantity';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: TextFormField(
                        controller: listPriceController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Medicine List Price',
                            labelText: 'List Price'),

//                    decoration: InputDecoration(
//                      enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(8)),
//                          borderSide: BorderSide(color: Colors.grey[200])),
//                      focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(8)),
//                          borderSide: BorderSide(color: Colors.grey[300])),
//                      hintText: 'Medicine list price',
//                    ),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter list price';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Consumer Price',
                            labelText: 'Consumer Price'),

//                    decoration: InputDecoration(
//                      enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(8)),
//                          borderSide: BorderSide(color: Colors.grey[200])),
//                      focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(8)),
//                          borderSide: BorderSide(color: Colors.grey[300])),
//                      hintText: 'Medicine Price',
                        //),
                        validator: (value) {
                          if (value.isEmpty) return 'Enter Price';
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.blue,
                            child: Text(
                              'Choose Image',
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: chooseFile,
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: takeImage,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: _image != null
                          ? Image.file(
                              _image,
                              height: 150,
                              width: 150,
                            )
                          : Container(
                              height: 150,
                              width: 150,
                              child: widget.product.imageUrl.length == 0
                                  ? Image.asset(
                                      'assets/images/medicine_icon.png',
                                    )
                                  : Image.network(widget.product.imageUrl),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _edit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      String imageUrl =
          _image != null ? await uploadImage(_image, nameController.text) : "";

      await
          //Firestore.instance.collection(Product.kEntity).document().setData({
          Firestore.instance
              .collection(Product.kEntity)
              .document(widget.product.id)
              .setData({
        Product.kName: nameController.text,
        Product.kDesc: descController.text,
        Product.kPrice: double.parse(priceController.text),
        Product.kListPrice: double.parse(listPriceController.text),
        Product.kAvailableQty:
            double.parse(qtyController.text) + widget.product.availableQty,
        Product.kModifiedTime: DateTime.now(),
        Product.kImageURL:
            imageUrl.length != 0 ? imageUrl : widget.product.imageUrl,
        Product.kSoldQty: widget.product.soldQuantity,
        Product.kSoldAmount: widget.product.soldAmount,
      }).then((value) {
        setState(() {
          _isLoading = false;
          _done = true;
          nameController.clear();
          descController.clear();
          qtyController.clear();
          priceController.clear();
          listPriceController.clear();
          _image = null;
        });
      });
    }
  }

  Future chooseFile() async {
//    ImagePicker imagePicker = ImagePicker();
    try {
      await _picker
          .getImage(source: ImageSource.gallery, imageQuality: 60)
          .then((value) {
        setState(() {
          _image = File(value.path);
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future takeImage() async {
//    ImagePicker imagePicker = ImagePicker();
    try {
      await _picker
          .getImage(source: ImageSource.camera, imageQuality: 60)
          .then((value) {
        setState(() {
          _image = File(value.path);
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // ignore: missing_return
  Future<String> uploadImage(File image, String medicineName) async {
    try {
      String name = 'medicine_$medicineName';
      final StorageReference storageReference =
          FirebaseStorage().ref().child(name);
      final StorageUploadTask uploadTask = storageReference.putFile(image);
      StorageTaskSnapshot response = await uploadTask.onComplete;
      String url = await response.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e.message);
    }
  }
}

import 'dart:io';
//import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dr_ahmed_medicine/product/product.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool _isLoading = false, _done = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController listPriceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File _image; //, _image2, _image3;
  ImagePicker _picker = ImagePicker();

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
                  onPressed: _add,
                  icon: Icon(Icons.done),
                ),
              ],
        title: Text('Add Medicine'),
      ),
      body: _isLoading
          ? Center(
              child: Loading(
                Colors.blue,
                Colors.red,
                Colors.yellow,
              ),
            )
          : _medicineAdd(),
    );
  }

  Widget _medicineAdd() {
    return _done
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Medicine is added successfully!',
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
                            inputDecoration.copyWith(hintText: 'Medicine Name'),
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
                            hintText: 'Medicine Description'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: TextFormField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(
                            hintText: 'Medicine Quantity'),
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
                          if (value.isEmpty) return 'Enter quantity';
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
                            hintText: 'Medicine List Price'),

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
                            hintText: 'Medicine Price'),

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
                              child: Image.asset(
                                'assets/images/medicine_icon.png',
                              ),
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

      String imageUrl =
          _image != null ? await uploadImage(_image, nameController.text) : "";

      await Firestore.instance.collection(Product.kEntity).document().setData({
        Product.kName: nameController.text,
        Product.kDesc: descController.text,
        Product.kPrice: double.parse(priceController.text),
        Product.kListPrice: double.parse(listPriceController.text),
        Product.kAvailableQty: double.parse(qtyController.text),
        Product.kModifiedTime: DateTime.now(),
        Product.kImageURL: imageUrl,
        Product.kSoldQty: 0.0,
        Product.kSoldAmount: 0.0,
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

/*
  Widget _displayImagesGrid() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.teal,
              ),
              onTap: () async {
                var image = await _picker.getImage(source: ImageSource.gallery);
                setState(() {
                  _image1 = File(image.path);
                });
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.teal,
              ),
              onTap: () async {
                var image2 = await _picker.getImage(source: ImageSource.camera);
                setState(() {
                  _image2 = File(image2.path);
                });
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.teal,
              ),
              onTap: () async {
                var image = await _picker.getImage(source: ImageSource.gallery);
                setState(() {
                  _image3 = File(image.path);
                });
              },
            ),
          ],
        ),
      ],
    );
  }*/

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

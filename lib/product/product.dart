import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  String description;
  String imageUrl;
  num price;
  num listPrice;
  num availableQty;
  Timestamp modifiedDate;
  num soldAmount;
  num soldQuantity;
  String id;

  Product(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.price,
      this.listPrice,
      this.availableQty,
      this.modifiedDate,
      this.soldAmount,
      this.soldQuantity});

  Product.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject[kId] != null ? jsonObject[kId] : "";
    this.name = jsonObject[kName] != null ? jsonObject[kName] : "";
    this.price = jsonObject[kPrice] != null ? jsonObject[kPrice] : 0.0;
    this.listPrice =
        jsonObject[kListPrice] != null ? jsonObject[kListPrice] : 0.0;
    this.modifiedDate = jsonObject[kModifiedTime] != null
        ? jsonObject[kModifiedTime]
        : Timestamp(0, 0);
    this.availableQty =
        jsonObject[kAvailableQty] != null ? jsonObject[kAvailableQty] : 0.0;
    this.imageUrl = jsonObject[kImageURL] != null ? jsonObject[kImageURL] : "";
    this.soldAmount =
        jsonObject[kSoldAmount] != null ? jsonObject[kSoldAmount] : 0.0;
    this.soldQuantity =
        jsonObject[kSoldQty] != null ? jsonObject[kSoldQty] : 0.0;
    this.description = jsonObject[kDesc] != null ? jsonObject[kDesc] : 0.0;
  }

  Map<String, dynamic> toJson() => {
        kId: id,
        kName: name,
        kImageURL: imageUrl,
        kAvailableQty: availableQty,
        kListPrice: listPrice,
        kPrice: price,
        kDesc: description,
      };

  static final String kEntity = 'Product';
  static final String kName = 'name';
  static final String kDesc = 'description';
  static final String kImageURL = 'image_url';
  static final String kPrice = 'price';
  static final String kListPrice = 'list_price';
  static final String kAvailableQty = 'available_quantity';
  static final String kModifiedTime = 'modified_time';
  static final String kSoldAmount = 'sold_amount';
  static final String kSoldQty = 'sold_quantity';
  static final String kId = 'document_id';
}

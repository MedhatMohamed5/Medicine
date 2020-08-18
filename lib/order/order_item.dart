import 'package:dr_ahmed_medicine/product/product.dart';

class OrderItem {
  Product product;
  double qty;
  double unitPrice;
  double unitDiscount;
  String id;
  num lineNumber;
  String orderId;

  OrderItem(
      {this.id,
      this.product,
      this.qty,
      this.unitPrice,
      this.unitDiscount,
      this.lineNumber,
      this.orderId});

  OrderItem.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.qty = jsonObject[kQty] != null ? jsonObject[kQty] : 0.0;
    this.unitPrice =
        jsonObject[kUnitPrice] != null ? jsonObject[kUnitPrice] : 0.0;
    this.unitDiscount =
        jsonObject[kUnitDiscount] != null ? jsonObject[kUnitDiscount] : 0.0;
    this.lineNumber =
        jsonObject[kLineNumber] != null ? jsonObject[kLineNumber] : 0.0;
    this.product = jsonObject[kProduct] != null
        ? Product.fromJson(jsonObject[kProduct])
        : Product();
    this.orderId = jsonObject[kOrderId] != null ? jsonObject[kOrderId] : "";
  }

  static List<OrderItem> toItemsList(List<dynamic> jsonObject) {
    List<OrderItem> items = [];

    for (var object in jsonObject) {
      items.add(OrderItem.fromJson(object));
    }

    return items;
  }

  Map<String, dynamic> toJson() => {
        kLineNumber: lineNumber,
        kQty: qty,
        kUnitDiscount: unitDiscount,
        kUnitPrice: unitPrice,
        kProduct: product.toJson(),
        kOrderId: orderId,
      };

  static final String kEntity = 'OrderItem';
  static final String kProduct = 'product';
  static final String kQty = 'quantity';
  static final String kUnitPrice = 'unit_price';
  static final String kUnitDiscount = 'unit_discount';
  static final String kLineNumber = 'line_number';
  static final String kOrderId = 'order_id';

  double totalAmount() {
    return this.qty * (this.unitPrice - this.unitDiscount);
  }
}

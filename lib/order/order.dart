import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_ahmed_medicine/customer/customer.dart';
import 'package:dr_ahmed_medicine/order/order_item.dart';

class Order {
  Customer customer;
  List<OrderItem> orderItems;
  String modifiedBy;
  Timestamp modifiedDate;
  num orderNumber;
  String id;
  bool isInvoiced;
  num paidAmount;

  Order({
    this.orderNumber,
    this.id,
    this.customer,
    this.orderItems,
    this.modifiedBy,
    this.modifiedDate,
    this.isInvoiced,
    this.paidAmount,
  });

  static final String kEntity = 'Order';
  static final String kCustomer = 'customer';
  static final String kOrderItems = 'order_items';
  static final String kModifiedBy = 'modified_by';
  static final String kModifiedDate = 'modified_date';
  static final String kOrderNumber = 'order_number';
  static final String kIsInvoiced = 'is_invoiced';
  static final String kPaidAmount = 'paid_amount';

  double getTotalAmount() {
    var total = 0.0;
    orderItems.forEach((element) {
      total += element
          .totalAmount(); //element.qty * (element.unitPrice - element.unitDiscount);
    });
    return total;
  }

  static List<Map<String, dynamic>> itemsToJson(List<OrderItem> list) {
    List<Map<String, dynamic>> toJson = [];
    list.forEach((element) {
      toJson.add(element.toJson());
    });
    return toJson;
  }
}

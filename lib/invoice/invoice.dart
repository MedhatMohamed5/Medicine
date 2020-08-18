import 'package:dr_ahmed_medicine/customer/customer.dart';
import 'package:dr_ahmed_medicine/invoice/invoice_item.dart';

class Invoice {
  List<InvoiceItem> invoiceItems;
  Customer customer;
  double totalAmount;
  double paidAmount;
}

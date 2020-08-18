class Customer {
  String id;
  String name;
  String phone;
  double totalInvoiceAmount;
  double totalPaidAmount;

  Customer({
    this.id,
    this.name,
    this.phone,
    this.totalInvoiceAmount,
    this.totalPaidAmount,
  });

  Customer.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.name = jsonObject[kName] != null ? jsonObject[kName] : "";
    this.phone = jsonObject[kPhone] != null ? jsonObject[kPhone] : "";
    this.totalInvoiceAmount = jsonObject[kTotalInvoiceAmount] != null
        ? jsonObject[kTotalInvoiceAmount]
        : 0.0;
    this.totalPaidAmount = jsonObject[kTotalPaidAmount] != null
        ? jsonObject[kTotalPaidAmount]
        : 0.0;
  }

  Map<String, dynamic> toJson() => {
        kName: name,
        kPhone: phone,
        kTotalInvoiceAmount: totalInvoiceAmount,
        kTotalPaidAmount: totalPaidAmount,
      };

  static final String kEntity = 'Customer';
  static final String kName = 'name';
  static final String kPhone = 'phone';
  static final String kTotalInvoiceAmount = 'total_invoice_amount';
  static final String kTotalPaidAmount = 'total_paid_amount';
}

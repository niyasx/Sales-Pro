import '../../domain/entities/sales_report_item.dart';

class SalesReportItemModel extends SalesReportItem {
  const SalesReportItemModel({
    required super.id,
    required super.invoiceNo,
    required super.date,
    required super.customerId,
    required super.customerName,
    required super.productId,
    required super.productName,
    required super.categoryId,
    required super.categoryName,
    required super.quantity,
    required super.rate,
    required super.discount,
    required super.amount,
  });

  factory SalesReportItemModel.fromJson(Map<String, dynamic> json) {
    return SalesReportItemModel(
      id: json['id'] as String,
      invoiceNo: json['invoiceNo'] as String,
      date: DateTime.parse(json['date'] as String),
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'date': date.toIso8601String(),
      'customerId': customerId,
      'customerName': customerName,
      'productId': productId,
      'productName': productName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'quantity': quantity,
      'rate': rate,
      'discount': discount,
      'amount': amount,
    };
  }

  SalesReportItem toEntity() {
    return SalesReportItem(
      id: id,
      invoiceNo: invoiceNo,
      date: date,
      customerId: customerId,
      customerName: customerName,
      productId: productId,
      productName: productName,
      categoryId: categoryId,
      categoryName: categoryName,
      quantity: quantity,
      rate: rate,
      discount: discount,
      amount: amount,
    );
  }

  factory SalesReportItemModel.fromEntity(SalesReportItem item) {
    return SalesReportItemModel(
      id: item.id,
      invoiceNo: item.invoiceNo,
      date: item.date,
      customerId: item.customerId,
      customerName: item.customerName,
      productId: item.productId,
      productName: item.productName,
      categoryId: item.categoryId,
      categoryName: item.categoryName,
      quantity: item.quantity,
      rate: item.rate,
      discount: item.discount,
      amount: item.amount,
    );
  }
}
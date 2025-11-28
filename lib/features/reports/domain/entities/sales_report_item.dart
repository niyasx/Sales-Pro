import 'package:equatable/equatable.dart';

class SalesReportItem extends Equatable {
  final String id;
  final String invoiceNo;
  final DateTime date;
  final String customerId;
  final String customerName;
  final String productId;
  final String productName;
  final String categoryId;
  final String categoryName;
  final double quantity;
  final double rate;
  final double discount;
  final double amount;

  const SalesReportItem({
    required this.id,
    required this.invoiceNo,
    required this.date,
    required this.customerId,
    required this.customerName,
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.rate,
    required this.discount,
    required this.amount,
  });

  @override
  List<Object> get props => [
        id,
        invoiceNo,
        date,
        customerId,
        customerName,
        productId,
        productName,
        categoryId,
        categoryName,
        quantity,
        rate,
        discount,
        amount,
      ];
}
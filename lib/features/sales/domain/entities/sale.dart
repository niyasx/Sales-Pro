import 'package:equatable/equatable.dart';

class Sale extends Equatable {
  final String id;
  final String invoiceNo;
  final DateTime date;
  final String customerId;
  final String customerName;
  final String customerAddress;
  final double totalQuantity;
  final double totalAmount;
  final DateTime createdAt;

  const Sale({
    required this.id,
    required this.invoiceNo,
    required this.date,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.totalQuantity,
    required this.totalAmount,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        invoiceNo,
        date,
        customerId,
        customerName,
        customerAddress,
        totalQuantity,
        totalAmount,
        createdAt,
      ];
}
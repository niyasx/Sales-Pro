import 'package:equatable/equatable.dart';

class SaleDetail extends Equatable {
  final String id;
  final String saleId;
  final int serialNo;
  final String productId;
  final String productName;
  final double quantity;
  final double rate;
  final double discount;
  final double amount;

  const SaleDetail({
    required this.id,
    required this.saleId,
    required this.serialNo,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.discount,
    required this.amount,
  });

  @override
  List<Object> get props => [
        id,
        saleId,
        serialNo,
        productId,
        productName,
        quantity,
        rate,
        discount,
        amount,
      ];
}
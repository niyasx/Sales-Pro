import 'package:equatable/equatable.dart';

class SaleItem extends Equatable {
  final String productId;
  final String productName;
  final String? productImage;
  final double quantity;
  final double rate;
  final double discount;
  final double amount;

  const SaleItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.rate,
    this.discount = 0,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        quantity,
        rate,
        discount,
        amount,
      ];

  SaleItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? quantity,
    double? rate,
    double? discount,
    double? amount,
  }) {
    return SaleItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      discount: discount ?? this.discount,
      amount: amount ?? this.amount,
    );
  }
}
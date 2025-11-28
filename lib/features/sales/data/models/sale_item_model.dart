import '../../domain/entities/sale_item.dart';

class SaleItemModel extends SaleItem {
  const SaleItemModel({
    required super.productId,
    required super.productName,
    super.productImage,
    required super.quantity,
    required super.rate,
    super.discount = 0,
    required super.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'rate': rate,
      'discount': discount,
      'amount': amount,
    };
  }

  SaleItem toEntity() {
    return SaleItem(
      productId: productId,
      productName: productName,
      productImage: productImage,
      quantity: quantity,
      rate: rate,
      discount: discount,
      amount: amount,
    );
  }

  factory SaleItemModel.fromEntity(SaleItem item) {
    return SaleItemModel(
      productId: item.productId,
      productName: item.productName,
      productImage: item.productImage,
      quantity: item.quantity,
      rate: item.rate,
      discount: item.discount,
      amount: item.amount,
    );
  }
}
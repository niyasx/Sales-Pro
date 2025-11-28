import '../../domain/entities/sale_detail.dart';

class SaleDetailModel extends SaleDetail {
  const SaleDetailModel({
    required super.id,
    required super.saleId,
    required super.serialNo,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.rate,
    required super.discount,
    required super.amount,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json, String id) {
    return SaleDetailModel(
      id: id,
      saleId: json['saleId'] as String,
      serialNo: json['serialNo'] as int,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saleId': saleId,
      'serialNo': serialNo,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'rate': rate,
      'discount': discount,
      'amount': amount,
    };
  }

  SaleDetail toEntity() {
    return SaleDetail(
      id: id,
      saleId: saleId,
      serialNo: serialNo,
      productId: productId,
      productName: productName,
      quantity: quantity,
      rate: rate,
      discount: discount,
      amount: amount,
    );
  }
}
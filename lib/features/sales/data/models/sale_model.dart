import '../../domain/entities/sale.dart';

class SaleModel extends Sale {
  const SaleModel({
    required super.id,
    required super.invoiceNo,
    required super.date,
    required super.customerId,
    required super.customerName,
    required super.customerAddress,
    required super.totalQuantity,
    required super.totalAmount,
    required super.createdAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as String,
      invoiceNo: json['invoiceNo'] as String,
      date: DateTime.parse(json['date'] as String),
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerAddress: json['customerAddress'] as String,
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'date': date.toIso8601String(),
      'customerId': customerId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'totalQuantity': totalQuantity,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Sale toEntity() {
    return Sale(
      id: id,
      invoiceNo: invoiceNo,
      date: date,
      customerId: customerId,
      customerName: customerName,
      customerAddress: customerAddress,
      totalQuantity: totalQuantity,
      totalAmount: totalAmount,
      createdAt: createdAt,
    );
  }

  factory SaleModel.fromEntity(Sale sale) {
    return SaleModel(
      id: sale.id,
      invoiceNo: sale.invoiceNo,
      date: sale.date,
      customerId: sale.customerId,
      customerName: sale.customerName,
      customerAddress: sale.customerAddress,
      totalQuantity: sale.totalQuantity,
      totalAmount: sale.totalAmount,
      createdAt: sale.createdAt,
    );
  }
}
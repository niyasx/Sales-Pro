import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String brandId;
  final String brandName;
  final double purchaseRate;
  final double salesRate;
  final String? imageUrl;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.brandId,
    required this.brandName,
    required this.purchaseRate,
    required this.salesRate,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        categoryId,
        categoryName,
        brandId,
        brandName,
        purchaseRate,
        salesRate,
        imageUrl,
        createdAt,
      ];
}
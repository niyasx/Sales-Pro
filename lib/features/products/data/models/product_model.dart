import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.categoryName,
    required super.brandId,
    required super.brandName,
    required super.purchaseRate,
    required super.salesRate,
    super.imageUrl,
    required super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      brandId: json['brandId'] as String,
      brandName: json['brandName'] as String,
      purchaseRate: (json['purchaseRate'] as num).toDouble(),
      salesRate: (json['salesRate'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'brandId': brandId,
      'brandName': brandName,
      'purchaseRate': purchaseRate,
      'salesRate': salesRate,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      brandId: brandId,
      brandName: brandName,
      purchaseRate: purchaseRate,
      salesRate: salesRate,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      brandId: product.brandId,
      brandName: product.brandName,
      purchaseRate: product.purchaseRate,
      salesRate: product.salesRate,
      imageUrl: product.imageUrl,
      createdAt: product.createdAt,
    );
  }
}
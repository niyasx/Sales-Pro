import '../../domain/entities/product_category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    required super.name,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductCategoryModel(
      id: id,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  ProductCategory toEntity() {
    return ProductCategory(
      id: id,
      name: name,
    );
  }
}
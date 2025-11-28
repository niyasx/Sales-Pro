import '../../domain/entities/product_brand.dart';

class ProductBrandModel extends ProductBrand {
  const ProductBrandModel({
    required super.id,
    required super.name,
  });

  factory ProductBrandModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductBrandModel(
      id: id,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  ProductBrand toEntity() {
    return ProductBrand(
      id: id,
      name: name,
    );
  }
}
import '../../domain/entities/customer_category.dart';

class CustomerCategoryModel extends CustomerCategory {
  const CustomerCategoryModel({
    required super.id,
    required super.name,
  });

  factory CustomerCategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CustomerCategoryModel(
      id: id,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  CustomerCategory toEntity() {
    return CustomerCategory(
      id: id,
      name: name,
    );
  }
}
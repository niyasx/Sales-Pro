import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.name,
    required super.address,
    required super.areaId,
    required super.areaName,
    required super.categoryId,
    required super.categoryName,
    required super.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      areaId: json['areaId'] as String,
      areaName: json['areaName'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'areaId': areaId,
      'areaName': areaName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      address: address,
      areaId: areaId,
      areaName: areaName,
      categoryId: categoryId,
      categoryName: categoryName,
      createdAt: createdAt,
    );
  }

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      name: customer.name,
      address: customer.address,
      areaId: customer.areaId,
      areaName: customer.areaName,
      categoryId: customer.categoryId,
      categoryName: customer.categoryName,
      createdAt: customer.createdAt,
    );
  }
}
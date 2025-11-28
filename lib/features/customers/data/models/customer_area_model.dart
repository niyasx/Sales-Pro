import '../../domain/entities/customer_area.dart';

class CustomerAreaModel extends CustomerArea {
  const CustomerAreaModel({
    required super.id,
    required super.name,
  });

  factory CustomerAreaModel.fromJson(Map<String, dynamic> json, String id) {
    return CustomerAreaModel(
      id: id,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  CustomerArea toEntity() {
    return CustomerArea(
      id: id,
      name: name,
    );
  }
}
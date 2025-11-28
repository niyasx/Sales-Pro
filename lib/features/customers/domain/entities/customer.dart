import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final String address;
  final String areaId;
  final String areaName;
  final String categoryId;
  final String categoryName;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.areaId,
    required this.areaName,
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        name,
        address,
        areaId,
        areaName,
        categoryId,
        categoryName,
        createdAt,
      ];
}
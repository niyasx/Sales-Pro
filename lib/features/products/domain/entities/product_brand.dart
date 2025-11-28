import 'package:equatable/equatable.dart';

class ProductBrand extends Equatable {
  final String id;
  final String name;

  const ProductBrand({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
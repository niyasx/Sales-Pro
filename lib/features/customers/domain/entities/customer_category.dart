import 'package:equatable/equatable.dart';

class CustomerCategory extends Equatable {
  final String id;
  final String name;

  const CustomerCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
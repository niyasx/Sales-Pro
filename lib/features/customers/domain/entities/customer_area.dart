import 'package:equatable/equatable.dart';

class CustomerArea extends Equatable {
  final String id;
  final String name;

  const CustomerArea({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
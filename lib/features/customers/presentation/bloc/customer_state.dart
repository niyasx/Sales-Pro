import 'package:equatable/equatable.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_area.dart';
import '../../domain/entities/customer_category.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomersLoaded extends CustomerState {
  final List<Customer> customers;
  final List<CustomerArea> areas;
  final List<CustomerCategory> categories;

  const CustomersLoaded({
    required this.customers,
    required this.areas,
    required this.categories,
  });

  @override
  List<Object> get props => [customers, areas, categories];

  CustomersLoaded copyWith({
    List<Customer>? customers,
    List<CustomerArea>? areas,
    List<CustomerCategory>? categories,
  }) {
    return CustomersLoaded(
      customers: customers ?? this.customers,
      areas: areas ?? this.areas,
      categories: categories ?? this.categories,
    );
  }
}

class CustomerOperationSuccess extends CustomerState {
  final String message;

  const CustomerOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError(this.message);

  @override
  List<Object> get props => [message];
}
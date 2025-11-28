import 'package:equatable/equatable.dart';
import '../../domain/entities/customer.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomersEvent extends CustomerEvent {
  const LoadCustomersEvent();
}

class LoadCustomerAreasEvent extends CustomerEvent {
  const LoadCustomerAreasEvent();
}

class LoadCustomerCategoriesEvent extends CustomerEvent {
  const LoadCustomerCategoriesEvent();
}

class CreateCustomerEvent extends CustomerEvent {
  final Customer customer;

  const CreateCustomerEvent(this.customer);

  @override
  List<Object> get props => [customer];
}

class UpdateCustomerEvent extends CustomerEvent {
  final Customer customer;

  const UpdateCustomerEvent(this.customer);

  @override
  List<Object> get props => [customer];
}

class DeleteCustomerEvent extends CustomerEvent {
  final String customerId;

  const DeleteCustomerEvent(this.customerId);

  @override
  List<Object> get props => [customerId];
}
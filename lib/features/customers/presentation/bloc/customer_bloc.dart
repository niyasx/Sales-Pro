import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_area.dart';
import '../../domain/entities/customer_category.dart';
import '../../domain/usecases/create_customer.dart';
import '../../domain/usecases/delete_customer.dart';
import '../../domain/usecases/get_customer_areas.dart';
import '../../domain/usecases/get_customer_categories.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/update_customer.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers getCustomers;
  final CreateCustomer createCustomer;
  final UpdateCustomer updateCustomer;
  final DeleteCustomer deleteCustomer;
  final GetCustomerAreas getCustomerAreas;
  final GetCustomerCategories getCustomerCategories;

  List<Customer> _customers = [];
  List<CustomerArea> _areas = [];
  List<CustomerCategory> _categories = [];

  CustomerBloc({
    required this.getCustomers,
    required this.createCustomer,
    required this.updateCustomer,
    required this.deleteCustomer,
    required this.getCustomerAreas,
    required this.getCustomerCategories,
  }) : super(const CustomerInitial()) {
    on<LoadCustomersEvent>(_onLoadCustomers);
    on<LoadCustomerAreasEvent>(_onLoadCustomerAreas);
    on<LoadCustomerCategoriesEvent>(_onLoadCustomerCategories);
    on<CreateCustomerEvent>(_onCreateCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<DeleteCustomerEvent>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());

    final result = await getCustomers(const NoParams());

    emit(
      result.fold(
        (failure) => CustomerError(failure.message),
        (customers) {
          _customers = customers;
          return CustomersLoaded(
            customers: _customers,
            areas: _areas,
            categories: _categories,
          );
        },
      ),
    );
  }
Future<void> _onLoadCustomerAreas(
  LoadCustomerAreasEvent event,
  Emitter<CustomerState> emit,
) async {
  debugPrint('🎯 LoadCustomerAreasEvent triggered');
  
  final result = await getCustomerAreas(const NoParams());

  result.fold(
    (failure) {
      debugPrint('❌ Failed to load areas: ${failure.message}');
      emit(CustomerError(failure.message));
    },
    (areas) {
      debugPrint('✅ Areas loaded successfully: ${areas.length}');
      _areas = areas;
      if (state is CustomersLoaded) {
        emit((state as CustomersLoaded).copyWith(areas: _areas));
      }
    },
  );
}

Future<void> _onLoadCustomerCategories(
  LoadCustomerCategoriesEvent event,
  Emitter<CustomerState> emit,
) async {
  debugPrint('🎯 LoadCustomerCategoriesEvent triggered');
  
  final result = await getCustomerCategories(const NoParams());

  result.fold(
    (failure) {
      debugPrint('❌ Failed to load categories: ${failure.message}');
      emit(CustomerError(failure.message));
    },
    (categories) {
      debugPrint('✅ Categories loaded successfully: ${categories.length}');
      _categories = categories;
      if (state is CustomersLoaded) {
        emit((state as CustomersLoaded).copyWith(categories: _categories));
      }
    },
  );
}

  Future<void> _onCreateCustomer(
    CreateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());

    final result = await createCustomer(event.customer);

    await result.fold(
      (failure) async => emit(CustomerError(failure.message)),
      (_) async {
        emit(const CustomerOperationSuccess('Customer created successfully'));
        add(const LoadCustomersEvent());
      },
    );
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());

    final result = await updateCustomer(event.customer);

    await result.fold(
      (failure) async => emit(CustomerError(failure.message)),
      (_) async {
        emit(const CustomerOperationSuccess('Customer updated successfully'));
        add(const LoadCustomersEvent());
      },
    );
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());

    final result = await deleteCustomer(event.customerId);

    await result.fold(
      (failure) async => emit(CustomerError(failure.message)),
      (_) async {
        emit(const CustomerOperationSuccess('Customer deleted successfully'));
        add(const LoadCustomersEvent());
      },
    );
  }
}
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/customer.dart';
import '../entities/customer_area.dart';
import '../entities/customer_category.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<Customer>>> getCustomers();
  Future<Either<Failure, Customer>> getCustomerById(String id);
  Future<Either<Failure, void>> createCustomer(Customer customer);
  Future<Either<Failure, void>> updateCustomer(Customer customer);
  Future<Either<Failure, void>> deleteCustomer(String id);
  Future<Either<Failure, List<CustomerArea>>> getCustomerAreas();
  Future<Either<Failure, List<CustomerCategory>>> getCustomerCategories();
}
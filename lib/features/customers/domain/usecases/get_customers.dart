import 'package:dartz/dartz.dart';
import 'package:sales_management_app/features/customers/domain/repositories/customer_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer.dart';

class GetCustomers implements UseCase<List<Customer>, NoParams> {
  final CustomerRepository repository;

  GetCustomers(this.repository);

  @override
  Future<Either<Failure, List<Customer>>> call(NoParams params) async {
    return await repository.getCustomers();
  }
}
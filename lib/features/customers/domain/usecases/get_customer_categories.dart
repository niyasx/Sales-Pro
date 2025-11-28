import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer_category.dart';
import '../repositories/customer_repository.dart';

class GetCustomerCategories implements UseCase<List<CustomerCategory>, NoParams> {
  final CustomerRepository repository;

  GetCustomerCategories(this.repository);

  @override
  Future<Either<Failure, List<CustomerCategory>>> call(NoParams params) async {
    return await repository.getCustomerCategories();
  }
}
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/sale_repository.dart';

class DeleteSale implements UseCase<void, String> {
  final SaleRepository repository;

  DeleteSale(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteSale(params);
  }
}
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSales implements UseCase<List<Sale>, NoParams> {
  final SaleRepository repository;

  GetSales(this.repository);

  @override
  Future<Either<Failure, List<Sale>>> call(NoParams params) async {
    return await repository.getSales();
  }
}
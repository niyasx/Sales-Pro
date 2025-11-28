import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_category.dart';
import '../repositories/product_repository.dart';

class GetProductCategories implements UseCase<List<ProductCategory>, NoParams> {
  final ProductRepository repository;

  GetProductCategories(this.repository);

  @override
  Future<Either<Failure, List<ProductCategory>>> call(NoParams params) async {
    return await repository.getProductCategories();
  }
}
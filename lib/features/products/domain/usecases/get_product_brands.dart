import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_brand.dart';
import '../repositories/product_repository.dart';

class GetProductBrands implements UseCase<List<ProductBrand>, NoParams> {
  final ProductRepository repository;

  GetProductBrands(this.repository);

  @override
  Future<Either<Failure, List<ProductBrand>>> call(NoParams params) async {
    return await repository.getProductBrands();
  }
}
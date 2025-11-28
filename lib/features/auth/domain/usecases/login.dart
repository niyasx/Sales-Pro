import 'package:dartz/dartz.dart';
import 'package:sales_management_app/core/usecases/usecase.dart';
import 'package:sales_management_app/features/auth/domain/entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
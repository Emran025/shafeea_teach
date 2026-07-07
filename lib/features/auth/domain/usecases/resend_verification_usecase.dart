import 'package:dartz/dartz.dart';
import '../../../../core/entities/success_entity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ResendVerificationEmailUseCase {
  final AuthRepository repository;
  ResendVerificationEmailUseCase(this.repository);

  Future<Either<Failure, SuccessEntity>> call() =>
      repository.resendEmailVerification();
}

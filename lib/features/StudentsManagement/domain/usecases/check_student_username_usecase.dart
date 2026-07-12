import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/student_repository.dart';

/// Fetches a username check from the backend for a given [name].
///
/// Used exclusively as a non-blocking UX hint when pre-filling the username
/// field in the student creation form. The result is NOT uniqueness-checked.
@lazySingleton
class CheckStudentUsernameUseCase {
  final StudentRepository _repository;

  CheckStudentUsernameUseCase(this._repository);

  Future<Either<Failure, bool>> call(String name) =>
      _repository.checkUsername(name);
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/teacher_repository.dart';

/// Fetches a username suggestion from the backend for a given [name].
///
/// Used exclusively as a non-blocking UX hint when pre-filling the username
/// field in the teacher creation form. The result is NOT uniqueness-checked.
@lazySingleton
class SuggestTeacherUsernameUseCase {
  final TeacherRepository _repository;

  SuggestTeacherUsernameUseCase(this._repository);

  Future<Either<Failure, String>> call(String name) =>
      _repository.suggestUsername(name);
}

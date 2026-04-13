// lib/features/teachers/domain/usecases/delete_teacher.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shafeea/core/error/failures.dart';
import 'package:shafeea/features/TeachersManagement/domain/usecases/usecase.dart';

import '../repositories/teacher_repository.dart';

@lazySingleton
class DeleteTeacherUseCase extends UseCase<Unit, String> {
  final TeacherRepository repository;

  DeleteTeacherUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String teacherId) async {
    return await repository.deleteTeacher(teacherId);
  }
}

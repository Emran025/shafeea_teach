import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shafeea/core/error/failures.dart';
import 'package:shafeea/core/usecases/usecase.dart';
import 'package:shafeea/features/StudentsManagement/domain/repositories/student_repository.dart';
import 'package:shafeea/features/settings/domain/entities/import_config.dart';
import 'package:shafeea/features/settings/domain/entities/import_summary.dart';

@injectable
class ImportFollowUpReportsUseCase
    extends UseCase<ImportSummary, ImportConfig> {
  final StudentRepository _studentRepository;

  ImportFollowUpReportsUseCase(this._studentRepository);

  @override
  Future<Either<Failure, ImportSummary>> call(ImportConfig params) async {
    // تم نقل المنطق بالكامل إلى داخل الدالة في الريبو
    return await _studentRepository.importFollowUpReports(config: params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:shafeea/core/error/failures.dart';
import 'package:shafeea/features/supervisor_dashboard/domain/entities/applicant_profile_entity.dart';
import 'package:shafeea/features/supervisor_dashboard/domain/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetApplicantProfileUseCase {
  final SupervisorRepository repository;

  GetApplicantProfileUseCase(this.repository);

  Future<Either<Failure, ApplicantProfileEntity>> call(int applicantId) async {
    return await repository.getApplicantProfile(applicantId);
  }
}

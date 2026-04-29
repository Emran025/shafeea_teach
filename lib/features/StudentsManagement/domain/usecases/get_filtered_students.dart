// lib/features/students/domain/usecases/get_student_by_id.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/active_status.dart';
import '../../../../core/models/monitoring_filter.dart';
import '../../../../core/models/report_frequency.dart';
import '../entities/student_list_item_entity.dart';
import '../repositories/student_repository.dart';
import 'usecase.dart';

@lazySingleton
class FetchFilteredStudentsUseCase extends UseCase<List<StudentListItemEntity>, GetFilteredStudentsParams> {
  final StudentRepository repository;

  FetchFilteredStudentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<StudentListItemEntity>>> call(
    GetFilteredStudentsParams params,
  ) async {
    return await repository.getFilteredStudents(
      status: params.status,
      halaqaUuid: params.halaqaUuid,
      trackDate: params.trackDate,
      frequencyCode: params.frequencyCode,
      monitoringFilter: params.monitoringFilter,
    );
  }
}


class GetFilteredStudentsParams extends Equatable {
 final ActiveStatus? status;
 final String? halaqaUuid;
 final DateTime? trackDate;
 final Frequency? frequencyCode;
 final MonitoringFilter monitoringFilter;

  const GetFilteredStudentsParams({
    this.status,
    this.halaqaUuid,
    this.trackDate,
    this.frequencyCode,
    this.monitoringFilter = MonitoringFilter.all,
  });

  @override
  List<Object?> get props => [status, halaqaUuid, trackDate, frequencyCode, monitoringFilter];
}

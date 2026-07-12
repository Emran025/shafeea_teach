part of 'student_bloc.dart';

enum StudentStatus { initial, loading, success, failure }

enum StudentInfoStatus { initial, loading, success, failure }

enum StudentSubmissionStatus { initial, submitting, success, failure }

enum StudentUpsertStatus { initial, submitting, success, failure }

enum FollowUpReportStatus { initial, loading, success, failure }

enum StudentUsernameSuggestionStatus { initial, loading, loaded, failure }
enum StudentUsernameCheckStatus { initial, loading, loaded, failure }

final class StudentState extends Equatable {
  final StudentStatus status;
  final List<StudentListItemEntity> students;
  final bool hasMorePages;
  final int currentPage;
  final Failure? failure;
  final bool isLoadingMore;

  // --- Details State Properties (New) ---
  final StudentInfoStatus detailsStatus;
  final StudentInfoEntity? selectedStudent;
  final Failure? detailsFailure;

  // --- Operation State (New) ---
  final StudentSubmissionStatus submissionStatus;
  final Failure? submissionFailure;
  // --- Operation State (New) ---
  final StudentUpsertStatus upsertStatus;
  final Failure? upsertFailure;
  // --- Operation State (New) ---
  final FollowUpReportStatus followUpReportStatus;
  final FollowUpReportBundleEntity? followUpReport;
  final Failure? followUpReportFailure;

  // New
  final StudentStatus  filteredStudentsStatus;
  final List<StudentListItemEntity>? filteredStudents;
  final Failure? filteredStudentsFailure;

  // --- Username Suggestion State ---
  final StudentUsernameSuggestionStatus usernameSuggestionStatus;
  final String usernameSuggestion;

  // --- Username Check State ---
  final StudentUsernameCheckStatus usernameCheckStatus;
  final bool usernameCheck;

  const StudentState({
    this.status = StudentStatus.initial,
    this.students = const [],
    this.hasMorePages = true,
    this.currentPage = 1,
    this.failure,
    this.isLoadingMore = false,

    // New
    this.detailsStatus = StudentInfoStatus.initial,
    this.selectedStudent,
    this.detailsFailure,

    // New
    this.submissionStatus = StudentSubmissionStatus.initial,
    this.submissionFailure,
    // New
    this.upsertStatus = StudentUpsertStatus.initial,
    this.upsertFailure,
    // New
    this.followUpReportStatus = FollowUpReportStatus.initial,
    this.followUpReport,
    this.followUpReportFailure,
    // New
    this.filteredStudentsStatus = StudentStatus.initial,
    this.filteredStudents,
    this.filteredStudentsFailure,

    // Username Suggestion
    this.usernameSuggestionStatus = StudentUsernameSuggestionStatus.initial,
    this.usernameSuggestion = '',

    // Username Check
    this.usernameCheckStatus = StudentUsernameCheckStatus.initial,
    this.usernameCheck = false,
  });

  StudentState copyWith({
    StudentStatus? status,
    List<StudentListItemEntity>? students,
    bool? hasMorePages,
    int? currentPage,
    Failure? failure,
    bool? isLoadingMore,

    // New
    StudentInfoStatus? detailsStatus,
    StudentInfoEntity? selectedStudent,
    Failure? detailsFailure,
    // Flags to clear specific errors
    bool clearListFailure = false,
    bool clearDetailsFailure = false,

    // New
    StudentSubmissionStatus? submissionStatus,
    Failure? submissionFailure,
    bool clearSubmissionFailure = false,
    // New
    StudentUpsertStatus? upsertStatus,
    Failure? upsertFailure,
    bool clearUpsertFailure = false,
    // New
    FollowUpReportStatus? followUpReportStatus,
    Failure? followUpReportFailure,
    FollowUpReportBundleEntity? followUpReport,
    bool clearFollowUpReportFailure = false,
    // New
    StudentStatus? filteredStudentsStatus,
    List<StudentListItemEntity>? filteredStudents,
    Failure? filteredStudentsFailure,
    bool clearFilteredStudentsFailure = false,
    List<ListItemEntity>? applicants,

    // Username Suggestion
    StudentUsernameSuggestionStatus? usernameSuggestionStatus,
    String? usernameSuggestion,

    // Username Check
    StudentUsernameCheckStatus? usernameCheckStatus,
    bool? usernameCheck,
  }) {
    return StudentState(
      status: status ?? this.status,
      students: students ?? this.students,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      currentPage: currentPage ?? this.currentPage,
      failure: clearListFailure ? null : failure ?? this.failure,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      // New
      detailsStatus: detailsStatus ?? this.detailsStatus,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      detailsFailure: clearDetailsFailure
          ? null
          : detailsFailure ?? this.detailsFailure,

      // New
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure: clearSubmissionFailure
          ? null
          : submissionFailure ?? this.submissionFailure,
      // New
      upsertStatus: upsertStatus ?? this.upsertStatus,
      upsertFailure: clearUpsertFailure
          ? null
          : upsertFailure ?? this.upsertFailure,
      // New
      followUpReportStatus: followUpReportStatus ?? this.followUpReportStatus,
      followUpReport: followUpReport ?? this.followUpReport,
      followUpReportFailure: clearFollowUpReportFailure
          ? null
          : followUpReportFailure ?? this.followUpReportFailure,
      // New
      filteredStudentsStatus: filteredStudentsStatus ?? this.filteredStudentsStatus,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      filteredStudentsFailure: clearFilteredStudentsFailure
          ? null
          : filteredStudentsFailure ?? this.filteredStudentsFailure,

      // Username Suggestion
      usernameSuggestionStatus:
          usernameSuggestionStatus ?? this.usernameSuggestionStatus,
      usernameSuggestion: usernameSuggestion ?? this.usernameSuggestion,

      // Username Check
      usernameCheckStatus:
          usernameCheckStatus ?? this.usernameCheckStatus,
      usernameCheck: usernameCheck ?? this.usernameCheck,
    );
  }

  @override
  List<Object?> get props => [
    status, students, hasMorePages, currentPage, failure, isLoadingMore, // New
    detailsStatus,
    selectedStudent,
    detailsFailure,
    submissionStatus,
    submissionFailure,
    upsertStatus,
    upsertFailure,
    followUpReportStatus,
    followUpReport,
    followUpReportFailure,
    filteredStudentsStatus,
    filteredStudents,
    filteredStudentsFailure,
    usernameSuggestionStatus,
    usernameSuggestion,
    usernameCheckStatus,
    usernameCheck,

  ];
}


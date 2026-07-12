part of 'teacher_bloc.dart';

enum TeacherStatus { initial, loading, success, failure }

enum TeacherDetailsStatus { initial, loading, success, failure }

enum TeacherSubmissionStatus { initial, submitting, success, failure }

enum TeacherUpsertStatus { initial, submitting, success, failure }

enum TeacherUsernameSuggestionStatus { initial, loading, loaded, failure }

enum TeacherUsernameCheckStatus { initial, loading, loaded, failure }

final class TeacherState extends Equatable {
  final TeacherStatus status;
  final List<TeacherListItemEntity> teachers;
  final bool hasMorePages;
  final int currentPage;
  final Failure? failure;
  final bool isLoadingMore;

  // --- Details State Properties (New) ---
  final TeacherDetailsStatus detailsStatus;
  final TeacherDetailEntity? selectedTeacher;
  final Failure? detailsFailure;

  // --- Operation State (New) ---
  final TeacherSubmissionStatus submissionStatus;
  final Failure? submissionFailure;
  // --- Operation State (New) ---
  final TeacherUpsertStatus upsertStatus;
  final Failure? upsertFailure;

  // --- Username Suggestion State ---
  final TeacherUsernameSuggestionStatus usernameSuggestionStatus;
  final String usernameSuggestion;

  // --- Username Check State ---
  final TeacherUsernameCheckStatus usernameCheckStatus;
  final bool usernameCheck;

  const TeacherState({
    this.status = TeacherStatus.initial,
    this.teachers = const [],
    this.hasMorePages = true,
    this.currentPage = 1,
    this.failure,
    this.isLoadingMore = false,

    // New
    this.detailsStatus = TeacherDetailsStatus.initial,
    this.selectedTeacher,
    this.detailsFailure,

    // New
    this.submissionStatus = TeacherSubmissionStatus.initial,
    this.submissionFailure,
    // New
    this.upsertStatus = TeacherUpsertStatus.initial,
    this.upsertFailure,

    // Username Suggestion
    this.usernameSuggestionStatus = TeacherUsernameSuggestionStatus.initial,
    this.usernameSuggestion = '',

    // Username Check
    this.usernameCheckStatus = TeacherUsernameCheckStatus.initial,
    this.usernameCheck = false,
  });

  TeacherState copyWith({
    TeacherStatus? status,
    List<TeacherListItemEntity>? teachers,
    bool? hasMorePages,
    int? currentPage,
    Failure? failure,
    bool? isLoadingMore,

    // New
    TeacherDetailsStatus? detailsStatus,
    TeacherDetailEntity? selectedTeacher,
    Failure? detailsFailure,
    // Flags to clear specific errors
    bool clearListFailure = false,
    bool clearDetailsFailure = false,

    // New
    TeacherSubmissionStatus? submissionStatus,
    Failure? submissionFailure,
    bool clearSubmissionFailure = false,
    // New
    TeacherUpsertStatus? upsertStatus,
    Failure? upsertFailure,
    bool clearUpsertFailure = false,

    // Username Suggestion
    TeacherUsernameSuggestionStatus? usernameSuggestionStatus,
    String? usernameSuggestion,

    // Username Check
    TeacherUsernameCheckStatus? usernameCheckStatus,
    bool? usernameCheck,
  }) {
    return TeacherState(
      status: status ?? this.status,
      teachers: teachers ?? this.teachers,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      currentPage: currentPage ?? this.currentPage,
      failure: clearListFailure ? null : failure ?? this.failure,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      // New
      detailsStatus: detailsStatus ?? this.detailsStatus,
      selectedTeacher: selectedTeacher ?? this.selectedTeacher,
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
    status, teachers, hasMorePages, currentPage, failure, isLoadingMore, // New
    detailsStatus,
    selectedTeacher,
    detailsFailure,
    submissionStatus,
    submissionFailure,
    upsertStatus,
    upsertFailure,
    usernameSuggestionStatus,
    usernameSuggestion,
    usernameCheckStatus,
    usernameCheck,
  ];
}

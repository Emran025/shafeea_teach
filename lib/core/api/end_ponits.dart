class EndPoint {
  // ── Server base URL ───────────────────────────────────────────────────────
  /// Resolved at compile-time from the `SHAFEEA_TEACH_API_URL` env variable.
  /// Pass with: `--dart-define=SHAFEEA_TEACH_API_URL=https://api.shafeeaTeach.app`
  /// Falls back to the Android emulator loopback address in development.
  static const String baseUrl = String.fromEnvironment('SHAFEEA_TEACH_API_URL');

  // ── Base prefix ───────────────────────────────────────────────────────────
  static const String v1 = '/api/v1';

  /// Endpoint for fetching a specific student's follow-up tracking records.
  /// The `{id}` placeholder will be replaced by the student's actual ID.
  static const String studentTrackings = '$v1/students/{id}/trackings';
  static const String logIn = "$v1/auth/login";
  static const String forgetPassword = "$v1/auth/forgot-password";
  static const String logOut = "$v1/auth/logout";
  static const String resendEmailVerification = "$v1/auth/email/resend";
  static const String me = "$v1/auth/me";
  static const String checkUsername = "$v1/auth/check-username";
  /// Public endpoint that returns a sanitized username candidate derived from
  /// a name string. No authentication required. No DB uniqueness check.
  /// Query param: `name` (raw name, Arabic or Latin).
  static const String usernameSuggest = "$v1/auth/username/suggest";
  static const String refreshToken = "$v1/refreshToken";
  static const String userProfile = "$v1/account/profile";
  static const String changePassword = "$v1/account/change-password";
  static const String sessions = "$v1/account/sessions";
  static const String studentApplicants =
      "$v1/admin/applicants?application_type={application_type}";
  static const String applicantProfile = "$v1/admin/applicants/{id}";
  static const String approveApplicant = "$v1/admin/applicants/{id}/approve";
  static const String rejectApplicant = "$v1/admin/applicants/{id}/reject";
  static const String privacyPolicy = "$v1/help/privacy-policy";
  static const String faqs = "$v1/help/faqs";
  static const String tickets = "$v1/help/tickets";
  static const String termsOfUse = "$v1/help/terms-of-use";
  static const String teachers = "$v1/teachers";
  static const String students = "$v1/students";
  static const String halaqas = "$v1/halaqas";
  static const String halaqasUpsert = "$v1/halaqas/{id}";
  static const String assignStudents = "$v1/halaqas/{halaqaId}/assign-students";
  static const String teachersSync = "$v1/sync/teachers";
  static const String studentsSync = "$v1/sync/students";
  static const String halaqasSync = "$v1/sync/halaqas";
  static const String trackingsSync = "$v1/sync/trackings";
  static const String teachersUpsert = "$v1/teachers/{id}";
  static const String studentsUpsert = "$v1/students/{id}";

  static String getUserDataEndPoint(id) {
    return "user/get-user/$id";
  }
}

class ApiKey {
  static String id = 'id';
  static String logIn = 'login';
  static String email = 'email';
  static String password = 'password';
  static String oldPassword = 'Oldpassword';
  static String verificationCode = 'VerificationCode';
  static String code = 'code';
  static String role = 'role';
  static String name = 'name';
  static String profileImagePath = 'profileImagePath';
  static String gender = 'gender';
  static String birthDate = 'birthDate';
  static String birthContery = 'birthContery';
  static String birthStates = 'birthStates';
  static String birthCity = 'birthCity';
  static String nationality = 'nationality';

  static String phoneNumber = 'phoneNumber';
  static String whatsappNumber = 'whatsappNumber';
  static String currentAddress = 'currentAddress';
  static String nameOfRelative = 'nameOfRelative';

  static String status = "status";
  static String message = "message";

  static String countryId = "countryId";
  static String isActive = "isActive";
  static String token = "token";
  static String confirmPassword = "confirmPassword";
  static String location = "location";

  static String roleId = 'roleId';
  static String firstName = 'firstName';
  static String lastName = 'lastName';
  static String phone = 'phone';

  static const String teacherID = 'teacher_id';

  static const String phoneZone = 'phone_zone';
  static const String whatsAppPhone = 'whats_app_phone';
  static const String whatsAppZone = 'whats_app_zone';
  static const String qualification = 'qualification';
  static const String experienceYears = 'experience_years';
  static const String country = 'country';
  static const String residence = 'residence';
  static const String city = 'city';
  static const String availableTime = 'available_time';
  static const String stopReasons = 'stop_reasons';
  static const String pic = 'pic';
  static const String halqas = 'halqas';
}

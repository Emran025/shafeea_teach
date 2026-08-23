import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shafeea/core/constants/countries_names.dart';
import 'package:shafeea/core/models/countery_model.dart';
import 'package:shafeea/shared/func/date_format.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/shared/widgets/country_picker_dialog.dart';
import 'package:shafeea/shared/widgets/custom_text_field.dart';
import 'package:shafeea/shared/widgets/phone_zone.dart';
import 'package:shafeea/shared/widgets/pick_date.dart';

import '../../../../../core/models/education_level.dart';
import '../../../../../shared/widgets/pick_time.dart';
import '../../bloc/teacher_bloc.dart';

/// A self-contained form for a single teacher.
///
/// All controllers are exposed as public fields so the hosting dialog can read
/// them directly when building the [TeacherDetailEntity] before dispatching
/// the upsert event.
///
/// Username behaviour
/// ------------------
/// * **Offline** (no internet connection): the username field is hidden.
///   The entity is submitted without a username and the server auto-assigns one.
/// * **Online**: the username field is shown.
///   - As soon as the user types a name the form dispatches
///     [TeacherUsernameRequested] to fetch a server-side suggestion.
///   - The suggestion is pre-filled into the username field.
///   - Whenever the user edits the username field the form dispatches
///     [TeacherUsernameCheckRequested] to validate availability.
///   - Visual feedback (loading spinner / tick / cross) is shown inline.
class TeacherForm extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController(
    text: "Male",
  );
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phoneZoneController = TextEditingController();
  final TextEditingController whatsAppPhoneController = TextEditingController();
  final TextEditingController whatsAppZoneController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController(
    text: EducationLevel.noFormalEducation.labelAr,
  );
  final TextEditingController experienceYearsController =
      TextEditingController();
  final TextEditingController eneregyController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();
  final TextEditingController memorizationLevelController =
      TextEditingController();
  final TextEditingController availableTimeController = TextEditingController();

  /// The desired username.  Non-null only when the device is online and the
  /// field has been populated (suggestion or manual entry).
  final TextEditingController usernameController = TextEditingController();

  TeacherForm({super.key});

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  late CountryModel selectedPhoneZone;
  late CountryModel selectedwhatsAppZone;
  late CountryModel selectedCountry;

  /// Whether the device currently has internet access.
  bool _isOnline = false;

  /// Tracks whether the connectivity check has completed.
  bool _connectivityChecked = false;

  @override
  void initState() {
    super.initState();
    selectedPhoneZone = countries[245];
    selectedwhatsAppZone = countries[245];
    selectedCountry = countries[245];

    // Check connectivity and keep the result in state.
    _checkConnectivity();

    // When the teacher's name changes, ask the backend for a username
    // suggestion (only dispatched when the device is online).
    widget.nameController.addListener(_onNameChanged);

    // When the username field is edited manually, check availability.
    widget.usernameController.addListener(_onUsernameChanged);
  }

  Future<void> _checkConnectivity() async {
    final online = await InternetConnection().hasInternetAccess;
    if (mounted) {
      setState(() {
        _isOnline = online;
        _connectivityChecked = true;
      });
    }
  }

  void _onNameChanged() {
    if (!_isOnline) return;
    final name = widget.nameController.text;
    context.read<TeacherBloc>().add(TeacherUsernameRequested(name));
  }

  void _onUsernameChanged() {
    if (!_isOnline) return;
    final username = widget.usernameController.text;
    context.read<TeacherBloc>().add(TeacherUsernameCheckRequested(username));
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_onNameChanged);
    widget.usernameController.removeListener(_onUsernameChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, top: 10),
        child: Column(
          children: [
            // ── Name ───────────────────────────────────────────────────────
            CustomTextField(
              controller: widget.nameController,
              prefixIcon: Icons.person,
              label: "اسم المعلم",
              keyboardType: TextInputType.name,
            ),

            // ── Gender ─────────────────────────────────────────────────────
            _buildDropdown(widget.genderController, "الجنس", [
              "Male",
              "Female",
            ]),

            // ── Username (online only) ──────────────────────────────────────
            if (_connectivityChecked && _isOnline)
              BlocBuilder<TeacherBloc, TeacherState>(
                buildWhen: (prev, curr) =>
                    prev.usernameSuggestionStatus !=
                        curr.usernameSuggestionStatus ||
                    prev.usernameSuggestion != curr.usernameSuggestion ||
                    prev.usernameCheckStatus != curr.usernameCheckStatus ||
                    prev.usernameCheck != curr.usernameCheck,
                builder: (context, state) {
                  // Pre-fill the field whenever a new suggestion arrives and
                  // the user has not already typed something custom.
                  if (state.usernameSuggestionStatus ==
                          TeacherUsernameSuggestionStatus.loaded &&
                      state.usernameSuggestion.isNotEmpty &&
                      widget.usernameController.text.isEmpty) {
                    // Schedule the update after the current build.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted &&
                          widget.usernameController.text.isEmpty) {
                        widget.usernameController.text =
                            state.usernameSuggestion;
                      }
                    });
                  }

                  return _buildUsernameField(state);
                },
              ),

            // ── Email ──────────────────────────────────────────────────────
            CustomTextField(
              controller: widget.emailController,
              prefixIcon: Icons.email,
              label: "البريد الإلكتروني",
              keyboardType: TextInputType.emailAddress,
            ),

            // ── Birth date ─────────────────────────────────────────────────
            CustomDatePicker(
              controller: widget.birthDateController,
              icon: Icons.calendar_month_outlined,
              label: "تأريخ الميلاد",
              onDateSelected: (date) {
                widget.birthDateController.text = formatDate(date);
              },
            ),

            // ── Phone ──────────────────────────────────────────────────────
            PhoneZoneForm(
              phoneController: widget.phoneController,
              zoneController: widget.phoneZoneController,
              initialCountry: selectedPhoneZone,
              onCountryChanged: () {
                setState(() {
                  selectedPhoneZone = countries
                      .where(
                        (x) =>
                            x.countryCallingCode ==
                            widget.phoneZoneController.text,
                      )
                      .first;
                });
              },
              label: "رقم الهاتف",
            ),

            // ── WhatsApp ───────────────────────────────────────────────────
            PhoneZoneForm(
              phoneController: widget.whatsAppPhoneController,
              zoneController: widget.whatsAppZoneController,
              initialCountry: selectedwhatsAppZone,
              onCountryChanged: () {
                setState(() {
                  selectedwhatsAppZone = countries
                      .where(
                        (x) =>
                            x.countryCallingCode ==
                            widget.phoneZoneController.text,
                      )
                      .first;
                });
              },
              label: "رقم الواتسآب",
            ),

            // ── Qualification ──────────────────────────────────────────────
            _buildDropdown(
              widget.qualificationController,
              "نوع التعليم(المهؤهل)",
              [...(EducationLevel.values.map((e) => e.labelAr).toList())],
            ),

            // ── Experience years ───────────────────────────────────────────
            CustomTextField(
              controller: widget.experienceYearsController,
              prefixIcon: Icons.calendar_month,
              label: "سنوات الخبرة",
              keyboardType: TextInputType.number,
            ),

            // ── Capacity ───────────────────────────────────────────────────
            CustomTextField(
              controller: widget.eneregyController,
              prefixIcon: Icons.group,
              label: "الطاقة الإستيعابية",
              keyboardType: TextInputType.number,
            ),

            // ── Country of birth ───────────────────────────────────────────
            CustomTextField(
              controller: widget.countryController,
              prefixIcon: Icons.home_filled,
              label: "محل الميلاد",
              onTap: _changeDialog,
              readOnly: true,
            ),

            // ── Country of residence ───────────────────────────────────────
            CustomTextField(
              controller: widget.residenceController,
              prefixIcon: Icons.home_filled,
              label: "بلد الإقامة",
              onTap: _changeDialog,
              readOnly: true,
            ),

            // ── Available time ─────────────────────────────────────────────
            CustomTimePicker(
              controller: widget.availableTimeController,
              icon: Icons.timelapse_rounded,
              label: "الوقت المتاح",
              onTimeSelected: (date) {
                widget.availableTimeController.text = "$date";
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Username field with inline status indicator ──────────────────────────

  Widget _buildUsernameField(TeacherState state) {
    // Determine the trailing status widget.
    Widget? suffixWidget;

    if (state.usernameCheckStatus == TeacherUsernameCheckStatus.loading ||
        state.usernameSuggestionStatus ==
            TeacherUsernameSuggestionStatus.loading) {
      suffixWidget = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (state.usernameCheckStatus ==
        TeacherUsernameCheckStatus.loaded) {
      suffixWidget = Icon(
        state.usernameCheck ? Icons.check_circle : Icons.cancel,
        color: state.usernameCheck ? Colors.green : AppColors.error,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: widget.usernameController,
        keyboardType: TextInputType.text,
        style: GoogleFonts.cairo(color: AppColors.lightCream70),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.lightCream12,
          prefixIcon: const Icon(Icons.alternate_email, color: AppColors.lightCream70),
          labelText: "اسم المستخدم",
          labelStyle: GoogleFonts.cairo(color: AppColors.lightCream70),
          helperText: state.usernameCheckStatus ==
                  TeacherUsernameCheckStatus.loaded
              ? (state.usernameCheck
                  ? "اسم المستخدم متاح ✓"
                  : "اسم المستخدم غير متاح")
              : null,
          helperStyle: GoogleFonts.cairo(
            color: state.usernameCheck ? Colors.green : AppColors.error,
            fontSize: 11,
          ),
          suffixIcon: suffixWidget != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: suffixWidget,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ── Country picker dialog ────────────────────────────────────────────────

  void _changeDialog(TextEditingController residence, String title) {
    showDialog(
      context: context,
      builder: (_) => CountryPickerDialog(
        initialCountry: selectedCountry,
        onCountrySelected: (country) {
          setState(() {
            selectedCountry = country;
            residence.text = country.arabicName;
          });
        },
        isCollingCode: true,
      ),
    );
  }

  // ── Generic dropdown ─────────────────────────────────────────────────────

  Widget _buildDropdown(
    TextEditingController controller,
    String label,
    List<String> options,
  ) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 12, left: 14),
      child: DropdownButtonFormField<String>(
        itemHeight: 50,
        style: GoogleFonts.cairo(color: AppColors.lightCream70),
        borderRadius: BorderRadius.circular(14),
        value: controller.text.trim(),
        dropdownColor: AppColors.mediumDark,
        items: options
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e == "Male"
                      ? "ذكر"
                      : e == "Female" || e == "female"
                      ? "أنثى"
                      : e,
                  style: GoogleFonts.cairo(
                    color: AppColors.lightCream70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (val) =>
            setState(() => controller.text = val ?? options.first),
        onSaved: (val) => controller.text = val ?? options.first,
        decoration: InputDecoration(
          fillColor: AppColors.lightCream12,
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: AppColors.lightCream70),
        ),
      ),
    );
  }
}

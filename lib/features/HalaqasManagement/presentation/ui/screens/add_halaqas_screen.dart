import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/core/constants/countries_names.dart';
import 'package:shafeea/core/models/countery_model.dart';
import 'package:shafeea/shared/widgets/avatar.dart';
import 'package:shafeea/shared/widgets/country_picker_dialog.dart';
import 'package:shafeea/shared/widgets/custom_text_field.dart';

import '../../../../../core/models/active_status.dart';
import '../../../../../core/models/gender.dart';
import '../../../../../features/StudentsManagement/presentation/bloc/student_bloc.dart';
import '../../../../../features/TeachersManagement/domain/entities/teacher_list_item_entity.dart';
import '../../../../../features/TeachersManagement/presentation/bloc/teacher_bloc.dart';
import '../../../../../shared/themes/app_theme.dart';
import '../../../../../shared/widgets/pick_time.dart';
import '../../../../StudentsManagement/domain/entities/student_list_item_entity.dart';

// ---------------------------------------------------------------------------
// HalaqaForm
// ---------------------------------------------------------------------------

/// A single halaqa creation form.
///
/// The [selectedTeacher] is controlled by the parent form list; once a teacher
/// is chosen through the picker, the circle name is pre-populated and the
/// teacher's real ID is used on submit.
class HalaqaForm extends StatefulWidget {
  /// A key that exposes the private state to the parent submit handler.
  final GlobalKey<_HalaqaFormState> stateKey = GlobalKey<_HalaqaFormState>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController(
    text: "Male",
  );
  final TextEditingController eneregyController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();
  final TextEditingController availableTimeController = TextEditingController();

  HalaqaForm({super.key});

  @override
  State<HalaqaForm> createState() => _HalaqaFormState();
}

class _HalaqaFormState extends State<HalaqaForm> {
  /// Students currently added to this new halaqa.
  List<StudentListItemEntity> currentStudents = [];

  /// The teacher selected from the capacity-aware picker dialog.
  /// Lives in State (not the widget) to satisfy @immutable.
  TeacherListItemEntity? selectedTeacher;
  
  late CountryModel selectedCountry;

  @override
  void initState() {
    // Students start empty; the picker populates them from StudentBloc.
    selectedCountry = countries[245];
    super.initState();
  }

  // ---------------------------------------------------------------------------
  // Student picker dialog — shows only unenrolled / inactive students
  // ---------------------------------------------------------------------------

  void _showStudentPickerDialog() {
    // Pull student list from the StudentBloc injected by the dialog launcher.
    final studentState = context.read<StudentBloc>().state;
    final allStudents = studentState.students;

    // Filter: students whose status is NOT active.
    // These are either:
    //   • never enrolled in a halaqa (inactive / pending / waiting), or
    //   • previously enrolled but now inactive / stopped.
    // Enrolling them in this new halaqa will mark them as active.
    final eligibleStudents = allStudents
        .where((s) => s.status != ActiveStatus.active)
        .toList();

    // Remove any student already added to this form.
    final available = eligibleStudents
        .where((s) => !currentStudents.any((c) => c.id == s.id))
        .toList();

    List<StudentListItemEntity> tempSelected = [...currentStudents];
    List<StudentListItemEntity> filtered = [...available];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStatee) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: AppColors.lightCream.withOpacity(0.1),
              insetPadding: const EdgeInsets.all(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxHeight: 540),
                  decoration: BoxDecoration(
                    color: AppColors.lightCream.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.lightCream26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----- Header -----
                      Text(
                        "إضافة طلاب للحلقة",
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightCream,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "يُعرض فقط الطلاب غير الملتحقين بحلقة نشطة",
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: AppColors.lightCream70,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ----- Search -----
                      TextField(
                        style: GoogleFonts.cairo(color: AppColors.lightCream),
                        onChanged: (val) {
                          setStatee(() {
                            filtered = available
                                .where((s) => s.name.contains(val))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "ابحث عن طالب...",
                          hintStyle: GoogleFonts.cairo(
                            color: AppColors.lightCream70,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.lightCream,
                          ),
                          filled: true,
                          fillColor: AppColors.lightCream.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ----- Student list -----
                      if (eligibleStudents.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  studentState.status == StudentStatus.loading
                                      ? Icons.hourglass_top_rounded
                                      : Icons.person_off_rounded,
                                  size: 48,
                                  color: AppColors.lightCream70,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  studentState.status == StudentStatus.loading
                                      ? "جارٍ تحميل الطلاب..."
                                      : "لا يوجد طلاب غير ملتحقين حاليًا",
                                  style: GoogleFonts.cairo(
                                    color: AppColors.lightCream70,
                                  ),
                                ),
                                if (studentState.status ==
                                    StudentStatus.loading) ...[
                                  const SizedBox(height: 12),
                                  const CircularProgressIndicator(),
                                ],
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: AppColors.lightCream26,
                              ),
                              itemBuilder: (_, i) {
                                final student = filtered[i];
                                final isSelected = tempSelected.any(
                                  (s) => s.id == student.id,
                                );

                                // Status badge colour
                                final badgeColor =
                                    student.status == ActiveStatus.stopped
                                    ? Colors.orange.withOpacity(0.3)
                                    : student.status == ActiveStatus.inactive
                                    ? Colors.red.withOpacity(0.2)
                                    : AppColors.accent.withOpacity(0.2);

                                return CheckboxListTile(
                                  value: isSelected,
                                  activeColor: AppColors.accent,
                                  selected: isSelected,
                                  selectedTileColor: AppColors.accent
                                      .withOpacity(0.08),
                                  title: Text(
                                    student.name,
                                    style: GoogleFonts.cairo(
                                      color: AppColors.lightCream,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        student.country,
                                        style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          color: AppColors.lightCream70,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: badgeColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          student.status.labelAr,
                                          style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            color: AppColors.lightCream,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    setStatee(() {
                                      if (val == true) {
                                        tempSelected.add(student);
                                      } else {
                                        tempSelected.removeWhere(
                                          (s) => s.id == student.id,
                                        );
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // ----- Actions -----
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.accent70),
                              ),
                              child: Text(
                                "إلغاء",
                                style: GoogleFonts.cairo(
                                  color: AppColors.lightCream,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                              ),
                              onPressed: () {
                                setState(() {
                                  currentStudents
                                    ..clear()
                                    ..addAll(tempSelected);
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                "إضافة (${tempSelected.length})",
                                style: GoogleFonts.cairo(
                                  color: AppColors.lightCream,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Capacity-aware teacher picker dialog
  // ---------------------------------------------------------------------------

  void _showTeacherPickerDialog() {
    // Read the teacher list emitted by TeacherBloc (injected by the dialog
    // launcher in halaqas_management_screen.dart).
    final teacherState = context.read<TeacherBloc>().state;
    final allTeachers = teacherState.teachers;

    // Filter: active teachers who have remaining halaqa capacity.
    final availableTeachers = allTeachers
        .where((t) => t.status == ActiveStatus.active && t.hasCapacity)
        .toList();

    TeacherListItemEntity? tempSelected = selectedTeacher;
    List<TeacherListItemEntity> filtered = [...availableTeachers];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setStatee) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: AppColors.lightCream.withOpacity(0.1),
              insetPadding: const EdgeInsets.all(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxHeight: 500),
                  decoration: BoxDecoration(
                    color: AppColors.lightCream.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.lightCream26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----- Header -----
                      Text(
                        "اختر معلمًا متاحًا",
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightCream,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "يُعرض فقط المعلمون الذين لديهم حلقات متاحة",
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: AppColors.lightCream70,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ----- Search -----
                      TextField(
                        style: GoogleFonts.cairo(color: AppColors.lightCream),
                        onChanged: (val) {
                          setStatee(() {
                            filtered = availableTeachers
                                .where((t) => t.name.contains(val))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "ابحث عن معلم...",
                          hintStyle: GoogleFonts.cairo(
                            color: AppColors.lightCream70,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.lightCream,
                          ),
                          filled: true,
                          fillColor: AppColors.lightCream.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ----- Teacher List -----
                      if (availableTeachers.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_off_rounded,
                                  size: 48,
                                  color: AppColors.lightCream70,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  teacherState.status == TeacherStatus.loading
                                      ? "جارٍ تحميل المعلمين..."
                                      : "لا يوجد معلمون متاحون حاليًا",
                                  style: GoogleFonts.cairo(
                                    color: AppColors.lightCream70,
                                  ),
                                ),
                                if (teacherState.status ==
                                    TeacherStatus.loading) ...[
                                  const SizedBox(height: 12),
                                  const CircularProgressIndicator(),
                                ],
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: AppColors.lightCream26,
                              ),
                              itemBuilder: (_, i) {
                                final teacher = filtered[i];
                                final isSelected =
                                    tempSelected?.id == teacher.id;
                                // Capacity label: e.g. "١ / ٣ حلقات"
                                final capacityLabel = teacher.maxHalaqas > 0
                                    ? "${teacher.currentHalaqas} / ${teacher.maxHalaqas} حلقات"
                                    : "${teacher.currentHalaqas} حلقة";

                                return RadioListTile<TeacherListItemEntity>(
                                  value: teacher,
                                  groupValue: tempSelected,
                                  activeColor: AppColors.accent,
                                  title: Text(
                                    teacher.name,
                                    style: GoogleFonts.cairo(
                                      color: AppColors.lightCream,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      // Country
                                      Text(
                                        teacher.country,
                                        style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          color: AppColors.lightCream70,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Capacity badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withOpacity(
                                            0.25,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: AppColors.accent70,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                          capacityLabel,
                                          style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            color: AppColors.lightCream,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected: isSelected,
                                  selectedTileColor: AppColors.accent
                                      .withOpacity(0.1),
                                  onChanged: (_) {
                                    setStatee(() => tempSelected = teacher);
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // ----- Actions -----
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.accent70),
                              ),
                              child: Text(
                                "إلغاء",
                                style: GoogleFonts.cairo(
                                  color: AppColors.lightCream,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                              ),
                              onPressed: tempSelected == null
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedTeacher = tempSelected;
                                        // Auto-populate circle name from the
                                        // selected teacher's name.
                                        if (widget.nameController.text
                                            .trim()
                                            .isEmpty) {
                                          widget.nameController.text =
                                              "حلقة ${tempSelected!.name}";
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                              child: Text(
                                "تأكيد",
                                style: GoogleFonts.cairo(
                                  color: AppColors.lightCream,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final teacher = selectedTeacher;

    return Form(
      key: widget.formKey,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, top: 10),
        child: Column(
          children: [
            // Circle name — pre-filled from teacher but editable.
            CustomTextField(
              controller: widget.nameController,
              prefixIcon: Icons.auto_stories_rounded,
              label: "اسم الحلقة",
              keyboardType: TextInputType.name,
            ),

            _buildDropdown(widget.genderController, "الجنس", [
              ...(Gender.values.map((e) => e.label).toList()),
            ]),
            CustomTextField(
              controller: widget.eneregyController,
              prefixIcon: Icons.group,
              label: "الطاقة الإستيعابية",
              keyboardType: TextInputType.number,
            ),

            CustomTextField(
              controller: widget.residenceController,
              prefixIcon: Icons.home_filled,
              label: "البلد",
              onTap: _changeCountryDialog,
              readOnly: true,
            ),

            CustomTimePicker(
              controller: widget.availableTimeController,
              icon: Icons.timelapse_rounded,
              label: "الوقت المتاح",
              onTimeSelected: (date) {
                widget.availableTimeController.text = "$date";
              },
            ),

            // ----------------------------------------------------------------
            // Teacher field — tap to open the capacity-aware picker.
            // ----------------------------------------------------------------
            GestureDetector(
              onTap: _showTeacherPickerDialog,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12, left: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightCream12,
                  borderRadius: BorderRadius.circular(12),
                  border: teacher == null
                      ? null
                      : Border.all(color: AppColors.accent70, width: 0.7),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_search_rounded,
                      color: AppColors.lightCream70,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: teacher == null
                          ? Text(
                              "اختر المعلم المسؤول عن الحلقة",
                              style: GoogleFonts.cairo(
                                color: AppColors.lightCream70,
                                fontSize: 14,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teacher.name,
                                  style: GoogleFonts.cairo(
                                    color: AppColors.lightCream,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  teacher.maxHalaqas > 0
                                      ? "${teacher.currentHalaqas} / ${teacher.maxHalaqas} حلقات"
                                      : "${teacher.currentHalaqas} حلقة حالياً",
                                  style: GoogleFonts.cairo(
                                    color: AppColors.lightCream70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    // Chip that shows selection status.
                    if (teacher != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "تغيير",
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: AppColors.lightCream,
                          ),
                        ),
                      )
                    else
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.lightCream70,
                        size: 14,
                      ),
                  ],
                ),
              ),
            ),

            // ----------------------------------------------------------------
            // Students section
            // ----------------------------------------------------------------
            GestureDetector(
              onTap: _showStudentPickerDialog,
              child: Row(
                children: [
                  const Icon(Icons.add, color: AppColors.mediumDark87),
                  const SizedBox(width: 8),
                  Text(
                    "إضافة طلاب",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightCream,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Divider(height: 2, color: AppColors.accent70),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SingleChildScrollView(
                child: Scrollbar(
                  child: Column(
                    children: currentStudents
                        .map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: _buildStudentCard(f),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Widget _buildStudentCard(StudentListItemEntity student) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        leading: Avatar(gender: student.gender),
        title: Text(
          student.name,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: AppColors.lightCream,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            student.status.label,
            style: GoogleFonts.cairo(fontSize: 12, color: AppColors.lightCream),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.playlist_remove_rounded,
            color: AppColors.lightCream,
          ),
          onPressed: () {
            setState(() {
              currentStudents.remove(student);
            });
          },
        ),
      ),
    );
  }

  void _changeCountryDialog(TextEditingController residence, String title) {
    showDialog(
      context: context,
      builder: (_) => CountryPickerDialog(
        initialCountry: selectedCountry,
        onCountrySelected: (country) {
          setState(() {
            selectedCountry = country;
            residence.text = country.arabicName;
            // Also populate countryController, which is what
            // AddHalaqaDialog._submitForms (in
            // halaqas_management_screen.dart) reads for the
            // HalaqaDetailEntity.country field. Without this, the
            // country picked here never reached the submitted entity.
            widget.countryController.text = country.arabicName;
          });
        },
        isCollingCode: true,
      ),
    );
  }

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
                  e == "Male" ? "ذكر" : "أنثى",
                  style: GoogleFonts.cairo(
                    color: AppColors.lightCream70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => controller.text = val ?? "Male"),
        onSaved: (val) => controller.text = val ?? "Male",
        decoration: InputDecoration(
          fillColor: AppColors.lightCream12,
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: AppColors.lightCream70),
        ),
      ),
    );
  }
}

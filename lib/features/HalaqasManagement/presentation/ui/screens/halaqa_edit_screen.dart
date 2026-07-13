import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/shared/widgets/taj.dart';

import '../../../../../config/di/injection.dart';
import '../../../../StudentsManagement/domain/entities/student_list_item_entity.dart';
import '../../../../StudentsManagement/presentation/bloc/student_bloc.dart';
import '../../../../TeachersManagement/domain/entities/teacher_list_item_entity.dart';
import '../../../../TeachersManagement/presentation/bloc/teacher_bloc.dart';
import '../../../presentation/bloc/halaqa_bloc.dart';

class HalaqaEditScreen extends StatefulWidget {
  final String halaqaId;
  const HalaqaEditScreen({super.key, required this.halaqaId});
  @override
  State<HalaqaEditScreen> createState() => _HalaqaEditScreenState();
}

class _HalaqaEditScreenState extends State<HalaqaEditScreen>
    with TickerProviderStateMixin {
  // Blocs owned and disposed by this screen.
  late final HalaqaBloc _halaqaBloc;
  late final TeacherBloc _teacherBloc;
  late final StudentBloc _currentStudentsBloc;

  @override
  void initState() {
    super.initState();
    _halaqaBloc = sl<HalaqaBloc>()
      ..add(HalaqaDetailsFetched(widget.halaqaId));
    _teacherBloc = sl<TeacherBloc>()..add(const WatchTeachersStarted());
    _currentStudentsBloc = sl<StudentBloc>()
      ..add(FilteredStudents(halaqaUuid: widget.halaqaId));
  }

  @override
  void dispose() {
    _halaqaBloc.close();
    _teacherBloc.close();
    _currentStudentsBloc.close();
    super.dispose();
  }

  /// Shows a picker dialog populated with candidate students
  /// (those NOT already enrolled in this halaqa) from a fresh StudentBloc.
  void _showStudentPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (ctx) => sl<StudentBloc>()
          ..add(FilteredStudents(notInHalaqaUuid: widget.halaqaId)),
        child: _CandidateStudentPickerDialog(),
      ),
    );
  }

  /// Shows the teacher-change dialog using real teachers from [TeacherBloc].
  void _changeTeacherDialog() {
    // Capture the teacher list before entering the dialog's build context.
    final List<TeacherListItemEntity> allTeachers =
        _teacherBloc.state.teachers;

    String tempSelected = allTeachers.isNotEmpty ? allTeachers.first.name : '';
    TextEditingController searchController = TextEditingController();
    List<TeacherListItemEntity> filteredTeachers = [...allTeachers];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: AppColors.lightCream12,
            insetPadding: EdgeInsets.all(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  color: AppColors.accent12,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.accent70, width: 0.7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تغيير المعلم",
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightCream,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      style: GoogleFonts.cairo(color: AppColors.lightCream),
                      onChanged: (val) {
                        setState(() {
                          filteredTeachers = allTeachers
                              .where((t) => t.name.contains(val))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "ابحث عن معلم...",
                        hintStyle: GoogleFonts.cairo(
                          color: AppColors.lightCream70,
                        ),
                        prefixIcon: Icon(
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
                    SizedBox(height: 12),
                    allTeachers.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "لا يوجد معلمون",
                                style: GoogleFonts.cairo(
                                  color: AppColors.lightCream70,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.separated(
                                itemCount: filteredTeachers.length,
                                separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: AppColors.lightCream26),
                                itemBuilder: (_, i) {
                                  final teacher = filteredTeachers[i];
                                  return RadioListTile<String>(
                                    value: teacher.name,
                                    groupValue: tempSelected,
                                    activeColor: AppColors.accent,
                                    title: Text(
                                      teacher.name,
                                      style: GoogleFonts.cairo(
                                        color: AppColors.lightCream,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        tempSelected = val!;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                    SizedBox(height: 12),
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
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                            ),
                            onPressed: () {
                              // Mutation wiring out of scope – stub only.
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
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(
    StudentListItemEntity student,
    void Function()? onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent70, width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        leading: student.avatar != ''
            ? CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(student.avatar),
              )
            : CircleAvatar(
                backgroundColor: AppColors.accent,
                radius: 15,
                child: Text(
                  student.name.isNotEmpty
                      ? student.name.substring(0, 1)
                      : '؟',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightCream,
                  ),
                ),
              ),
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
            student.status.labelAr,
            style:
                GoogleFonts.cairo(fontSize: 12, color: AppColors.lightCream),
          ),
        ),
        onTap: () {},
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                if (onPressed != null) onPressed();
              },
              child: StatusTag(lable: "اتخاذ اجراء"),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: AppColors.lightCream),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }

  void _editHalqaNameDialog() {
    final currentName =
        _halaqaBloc.state.selectedHalaqa?.name ?? '';
    TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.lightCream.withOpacity(0.1),
        insetPadding: const EdgeInsets.all(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightCream.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.lightCream38),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit, color: AppColors.lightCream),
                    const SizedBox(width: 8),
                    Text(
                      "تعديل اسم الحلقة",
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightCream,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: GoogleFonts.cairo(color: AppColors.lightCream),
                  cursorColor: AppColors.lightCream,
                  decoration: InputDecoration(
                    hintText: "ادخل اسم الحلقة الجديد...",
                    hintStyle:
                        GoogleFonts.cairo(color: AppColors.lightCream70),
                    labelText: "اسم الحلقة",
                    labelStyle: GoogleFonts.cairo(
                      color: AppColors.lightCream70,
                    ),
                    prefixIcon: const Icon(
                      Icons.school,
                      color: AppColors.lightCream,
                    ),
                    filled: true,
                    fillColor: AppColors.lightCream.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.mediumDark87,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                          style:
                              GoogleFonts.cairo(color: AppColors.lightCream),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                        ),
                        onPressed: () {
                          // Mutation wiring out of scope – stub only.
                          Navigator.pop(context);
                        },
                        child: Text(
                          "تأكيد",
                          style:
                              GoogleFonts.cairo(color: AppColors.lightCream),
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
  }

  void _showStudentActionDialog(StudentListItemEntity student) {
    String action = "";
    TextEditingController noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: AppColors.lightCream.withOpacity(0.1),
            insetPadding: EdgeInsets.all(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent12,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.accent70, width: 0.7),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "إدارة الطالب",
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightCream,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ["نقل", "فصل", "إيقاف"].map((action1) {
                        final isSelected = action == action1;
                        return ChoiceChip(
                          label: Text(
                            action1,
                            style: GoogleFonts.cairo(
                              color: isSelected
                                  ? AppColors.lightCream
                                  : AppColors.mediumDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          backgroundColor:
                              AppColors.accent70.withOpacity(0.3),
                          onSelected: (_) =>
                              setStateDialog(() => action = action1),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.lightCream26,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: noteCtrl,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "أضف ملاحظة (اختياري)",
                        hintStyle: GoogleFonts.cairo(
                          color: AppColors.lightCream70,
                        ),
                        filled: true,
                        fillColor: AppColors.lightCream12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style:
                          GoogleFonts.cairo(color: AppColors.lightCream),
                    ),
                    SizedBox(height: 16),
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
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                            ),
                            onPressed: () {
                              // Mutation wiring out of scope – stubs only.
                              Navigator.pop(context);
                            },
                            child: Text(
                              "تنفيذ",
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _halaqaBloc),
        BlocProvider.value(value: _teacherBloc),
        BlocProvider.value(value: _currentStudentsBloc),
      ],
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: Text(
            "تعديل الحلقة",
            style: GoogleFonts.cairo(color: AppColors.lightCream),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Info card: halaqa name + teacher + add students button
                BlocBuilder<HalaqaBloc, HalaqaState>(
                  builder: (ctx, halaqaState) {
                    final halaqa = halaqaState.selectedHalaqa;
                    final halaqaName = halaqa?.name ?? '…';
                    final teacherName = halaqa?.teacherName.isNotEmpty == true
                        ? halaqa!.teacherName
                        : 'معلم غير محدد';
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.lightCream12,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: AppColors.lightCream12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInfoRow(
                                icon: Icons.school,
                                label: "اسم الحلقة:",
                                value: halaqaName,
                                onEdit: _editHalqaNameDialog,
                              ),
                              const SizedBox(height: 16),
                              buildInfoRow(
                                icon: Icons.person,
                                label: "المعلم الحالي:",
                                value: teacherName,
                                onEdit: _changeTeacherDialog,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.group_add,
                                    color: AppColors.lightCream70,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "أضف طلاب للحلقة:",
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      color: AppColors.lightCream,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: _showStudentPickerDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      foregroundColor:
                                          AppColors.lightCream,
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "اختر طلاب",
                                      style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
                // Current students list from StudentBloc
                Expanded(
                  child: BlocBuilder<StudentBloc, StudentState>(
                    builder: (ctx, studentState) {
                      final students =
                          studentState.filteredStudents ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people, color: AppColors.accent),
                              SizedBox(width: 8),
                              Text(
                                "الطلاب الحاليين",
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightCream,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${students.length}",
                                style: GoogleFonts.cairo(
                                  color: AppColors.lightCream,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            child: students.isEmpty
                                ? Center(
                                    child: Text(
                                      "لا يوجد طلاب في هذه الحلقة",
                                      style: GoogleFonts.cairo(
                                        color: AppColors.lightCream70,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: students.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (_, i) {
                                      return _buildStudentCard(
                                          students[i], () {
                                        _showStudentActionDialog(
                                            students[i]);
                                      });
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A self-contained dialog that owns its own [StudentBloc] providing candidate
/// students (not in the halaqa). Must be wrapped by a [BlocProvider<StudentBloc>]
/// from the caller.
class _CandidateStudentPickerDialog extends StatefulWidget {
  const _CandidateStudentPickerDialog();
  @override
  State<_CandidateStudentPickerDialog> createState() =>
      _CandidateStudentPickerDialogState();
}

class _CandidateStudentPickerDialogState
    extends State<_CandidateStudentPickerDialog> {
  final List<StudentListItemEntity> _tempSelected = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (ctx, state) {
        final allCandidates = state.filteredStudents ?? [];
        final filtered = _searchQuery.isEmpty
            ? allCandidates
            : allCandidates
                .where((s) => s.name.contains(_searchQuery))
                .toList();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.black45,
          insetPadding: EdgeInsets.all(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                color: AppColors.accent12,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accent70, width: 0.7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إضافة طلاب للحلقة",
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightCream,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    style: GoogleFonts.cairo(color: AppColors.lightCream),
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "ابحث عن طالب...",
                      hintStyle: GoogleFonts.cairo(
                        color: AppColors.lightCream70,
                      ),
                      prefixIcon: Icon(
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
                  SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "لا يوجد طلاب متاحون",
                              style: GoogleFonts.cairo(
                                color: AppColors.lightCream70,
                              ),
                            ),
                          )
                        : Scrollbar(
                            thumbVisibility: true,
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: AppColors.lightCream26),
                              itemBuilder: (_, i) {
                                final student = filtered[i];
                                final selected =
                                    _tempSelected.contains(student);
                                return CheckboxListTile(
                                  value: selected,
                                  title: Text(
                                    student.name,
                                    style: GoogleFonts.cairo(
                                      color: AppColors.lightCream,
                                    ),
                                  ),
                                  activeColor: AppColors.accent,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _tempSelected.add(student);
                                      } else {
                                        _tempSelected.remove(student);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                  SizedBox(height: 12),
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
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                          ),
                          onPressed: () {
                            // Mutation wiring out of scope – stub only.
                            Navigator.pop(context);
                          },
                          child: Text(
                            "إضافة",
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
        );
      },
    );
  }
}

class DailyLog {
  final DateTime dateTime;
  final String memorization;
  final String recitation;
  final String revison;
  final String notes;

  DailyLog(
    this.dateTime,
    this.recitation,
    this.revison,
    this.memorization,
    this.notes,
  );
}

Widget buildInfoRow({
  required IconData icon,
  required String label,
  required String value,
  required VoidCallback onEdit,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, color: AppColors.lightCream70, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 16,
          color: AppColors.lightCream,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.lightCream12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.lightCream,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      const SizedBox(width: 8),
      InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "تعديل",
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.lightCream,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}

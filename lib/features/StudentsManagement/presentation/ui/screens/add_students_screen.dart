import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/core/models/gender.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/core/constants/countries_names.dart';
import 'package:shafeea/core/models/countery_model.dart';
import 'package:shafeea/shared/func/date_format.dart';
import 'package:shafeea/shared/widgets/country_picker_dialog.dart';
import 'package:shafeea/shared/widgets/custom_text_field.dart';
import 'package:shafeea/shared/widgets/phone_zone.dart';
import 'package:shafeea/shared/widgets/pick_date.dart';
import 'package:shafeea/features/daily_tracking/presentation/pages/quran_memorization_picker.dart';

import '../../../../../core/models/education_level.dart';
import '../../../../../shared/widgets/pick_time.dart';

class StudentForm extends StatefulWidget {
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
  final TextEditingController memorizationLevelController =
      TextEditingController();
  final TextEditingController eneregyController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();

  final TextEditingController availableTimeController = TextEditingController();

  StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  late CountryModel selectedPhoneZone;
  late CountryModel selectedwhatsAppZone;
  late CountryModel selectedCountry;

  @override
  void initState() {
    selectedPhoneZone = countries[245];
    selectedwhatsAppZone = countries[245];
    selectedCountry = countries[245];
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, top: 10),
        child: Column(
          children: [
            CustomTextField(
              controller: widget.nameController,
              prefixIcon: Icons.person,
              label: "اسم الطالب",
              keyboardType: TextInputType.name,
            ),
            _buildDropdown(widget.genderController, "الجنس", [
              ...(Gender.values.map((e) => e.label).toList()),
            ]),
            CustomTextField(
              controller: widget.emailController,
              prefixIcon: Icons.email,
              label: "البريد الإلكتروني",
              keyboardType: TextInputType.emailAddress,
            ),
            CustomDatePicker(
              controller: widget.birthDateController,
              icon: Icons.calendar_month_outlined,
              label: "تأريخ الميلاد",
              onDateSelected: (date) {
                widget.birthDateController.text = formatDate(date);
                // birthDate.text = date
                //     .toIso8601String()
                //     .split('T')
                //     .first; // Format date to YYYY-MM-DD;
              },
            ),

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

            _buildDropdown(
              widget.qualificationController,
              "نوع التعليم(المهؤهل)",
              [...(EducationLevel.values.map((e) => e.labelAr).toList())],
            ),

            CustomTextField(
              controller: widget.memorizationLevelController,
              prefixIcon: Icons.calendar_month,
              keyboardType: TextInputType.number,
              label: "المستوى في الحفظ",
              onTap: _openMemorizationPicker,
              readOnly: true,
            ),

            CustomTextField(
              controller: widget.countryController,
              prefixIcon: Icons.home_filled,
              label: "محل الميلاد",
              onTap: _changeDialog,
              readOnly: true,
            ),
            CustomTextField(
              controller: widget.residenceController,
              prefixIcon: Icons.home_filled,
              label: "بلد الإقامة",
              onTap: _changeDialog,
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
          ],
        ),
      ),
    );
  }

  // Opens the Quran memorization range picker and writes the returned
  // signed page count into the "المستوى في الحفظ" field instead of allowing
  // manual typing.
  void _openMemorizationPicker(
    TextEditingController memorizationLevel,
    String title,
  ) {
    showQuranMemorizationPickerDialog(
      context: context,
      onConfirm: (fromPage, toPage, fromInfo, toInfo, signedPages) {
        setState(() {
          memorizationLevel.text = "$signedPages";
        });
      },
    );
  }

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

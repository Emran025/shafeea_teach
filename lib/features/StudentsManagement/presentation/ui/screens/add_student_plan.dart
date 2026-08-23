import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/core/models/report_frequency.dart';
import 'package:shafeea/core/models/tracking_type.dart';
import 'package:shafeea/core/models/tracking_units.dart';
import 'package:shafeea/shared/widgets/custom_text_field.dart';

class StudentsPlanForm extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  StudentsPlanForm({super.key});

  @override
  State<StudentsPlanForm> createState() => _StudentsPlanFormState();
}

class _StudentsPlanFormState extends State<StudentsPlanForm> {
  // Controllers
  TextEditingController studyPlanType = TextEditingController(text: L10nStrings.AppStrings.daily);

  Map<TrackingType, TextEditingController> unitTypeControllers = {
    TrackingType.memorization: TextEditingController(text: L10nStrings.AppStrings.page),
    TrackingType.review: TextEditingController(text: L10nStrings.AppStrings.page),
    TrackingType.recitation: TextEditingController(text: L10nStrings.AppStrings.page),
  };
  final Map<TrackingType, TextEditingController> quantityControllers = {
    TrackingType.memorization: TextEditingController(),
    TrackingType.review: TextEditingController(),
    TrackingType.recitation: TextEditingController(),
  };

  // Widget داخل الـ build

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nStrings.AppStrings.followUpPlan,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.lightCream87,
            ),
          ),
          SizedBox(height: 10),
          _buildDropdown(
            studyPlanType,
            L10nStrings.AppStrings.followUpPlanType,
            Frequency.values.map((element) => element.labelAr).toList(),
          ),
          ...TrackingType.values.toList().map(
            (type) => Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    "إعدادات ال${type.labelAr}",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightCream70,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        unitTypeControllers[type]!,
                        "وحدة ال${type.labelAr}",
                        TrackingUnitTyps.values
                            .map((element) => element.labelAr)
                            .toList(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        controller: quantityControllers[type]!,
                        prefixIcon: Icons.format_list_numbered,
                        label: L10nStrings.AppStrings.numberLabel,
                        keyboardType: TextInputType.number,
                        padding: EdgeInsets.only(bottom: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        style: GoogleFonts.cairo(color: AppColors.lightCream70),
        borderRadius: BorderRadius.circular(14),
        value: controller.text.trim(),
        dropdownColor: AppColors.mediumDark,

        items: options
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: GoogleFonts.cairo(
                    color: AppColors.lightCream70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => controller.text = val ?? L10nStrings.AppStrings.page),
        onSaved: (val) => controller.text = val ?? L10nStrings.AppStrings.page,
        padding: EdgeInsets.all(0),
        decoration: InputDecoration(
          fillColor: AppColors.lightCream12,
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: AppColors.lightCream70),
        ),
      ),
    );
  }
}

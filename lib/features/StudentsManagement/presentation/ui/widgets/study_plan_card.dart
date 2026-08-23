import 'package:shafeea_teach/core/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shafeea/shared/themes/app_theme.dart';
import '../../../domain/entities/plan_detail_entity.dart';

class StudyPlanCard extends StatefulWidget {
  final String planType;

  final List<PlanDetailEntity> planDetailList;
  final VoidCallback? onPress;
  const StudyPlanCard({
    super.key,
    required this.planType,
    required this.planDetailList,
    required this.onPress,
  });

  @override
  State<StudyPlanCard> createState() => _StudyPlanCardState();
}

class _StudyPlanCardState extends State<StudyPlanCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.accent12
              : AppColors.mediumDark54,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.accent70, width: 0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📝 نوع الخطة: ${widget.planType}",
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightCream87,
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.onPress!(),
                  child: Icon(Icons.edit, color: AppColors.accent70),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accent12
                    : AppColors.mediumDark,
                width: 0.5,
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.accent26
                        : AppColors.mediumDark,
                  ),
                  children: [
                    _buildTableHeader(AppStrings.str_teach_rem_149_1f2b),
                    _buildTableHeader(AppStrings.str_teach_rem_150_2e7b),
                    _buildTableHeader(AppStrings.str_teach_rem_151_0cc4),
                  ],
                ),
                ...[...widget.planDetailList].map(
                  (planDetail) => TableRow(
                    children: [
                      _buildTableCell(planDetail.type.labelAr),
                      _buildTableCell(planDetail.unit.labelAr),
                      _buildTableCell("${planDetail.amount}"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.lightCream70,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: GoogleFonts.cairo(fontSize: 12, color: AppColors.lightCream),
      ),
    );
  }
}

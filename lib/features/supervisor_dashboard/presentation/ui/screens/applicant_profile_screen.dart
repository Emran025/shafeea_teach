import 'package:shafeea_teach/core/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/shared/widgets/avatar.dart';
import 'package:shafeea/features/supervisor_dashboard/domain/entities/applicant_profile_entity.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/bloc/supervisor_bloc.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/widgets/approve_applicant_dialog.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/widgets/reject_applicant_dialog.dart';

import '../../../../../core/models/gender.dart';
import '../../../../TeachersManagement/presentation/ui/widgets/documents_section.dart';

class ApplicantProfileScreen extends StatefulWidget {
  final int applicantId;

  const ApplicantProfileScreen({super.key, required this.applicantId});

  @override
  State<ApplicantProfileScreen> createState() => _ApplicantProfileScreenState();
}

class _ApplicantProfileScreenState extends State<ApplicantProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SupervisorBloc>().add(
      ApplicantProfileFetched(widget.applicantId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.str_teach_rem_355_2ead)),
      body: BlocListener<SupervisorBloc, SupervisorState>(
        listener: (context, state) {
          if (state is SupervisorLoaded) {
            if (state.applicantProfile == null) {
              Navigator.of(context).pop();
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<SupervisorBloc>().add(ClearMessage());
            }
          }
        },
        child: BlocBuilder<SupervisorBloc, SupervisorState>(
          builder: (context, state) {
            if (state is SupervisorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SupervisorLoaded &&
                state.applicantProfile != null) {
              return _buildSuccessfulUI(context, state.applicantProfile!);
            } else if (state is SupervisorError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text(AppStrings.str_teach_rem_356_392d));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSuccessfulUI(
    BuildContext context,
    ApplicantProfileEntity applicant,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            _buildHeader(context, applicant.user),
            const SizedBox(height: 24),
            _buildInfoRow(AppStrings.str_teach_rem_93_c920, applicant.user.email),
            _buildInfoRow(AppStrings.str_teach_rem_95_a44d, applicant.user.phone),
            _buildInfoRow(AppStrings.str_teach_rem_22_223a, applicant.user.gender),
            _buildInfoRow(AppStrings.str_teach_rem_357_e7a9, applicant.user.country),
            _buildInfoRow(AppStrings.str_teach_rem_119_d4ff, applicant.user.city),
            _buildInfoRow(AppStrings.str_teach_rem_358_5d25, applicant.qualifications ?? ''),
            _buildInfoRow('بيان النوايا', applicant.intentStatement ?? ''),
            const SizedBox(height: 24),
            DocumentsSection(documents: applicant.documents),
            const SizedBox(height: 24),
            _buildActionButtons(context, applicant),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ApplicantProfileEntity applicant,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<SupervisorBloc>(context),
                  child: RejectApplicantDialog(applicantId: applicant.id),
                ),
              );
              if (result == true) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text(AppStrings.str_teach_rem_126_5ea6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<SupervisorBloc>(context),
                  child: ApproveApplicantDialog(
                    applicantId: applicant.id,
                    onConfirm: () {
                      context.read<SupervisorBloc>().add(
                        ApproveApplicant(applicant.id),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: const Text(AppStrings.str_teach_rem_127_d99d),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.lightCream.withOpacity(0.1)
            : AppColors.mediumDark70,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightCream38),
      ),
      child: Row(
        children: [
          Avatar(gender: Gender.fromLabel(user.gender), pic: user.avatar),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightCream,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppStrings.str_teach_rem_359_7ce7,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppColors.lightCream,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.lightCream12
            : AppColors.mediumDark87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.cairo(color: AppColors.lightCream70)),
          Text(
            value ?? '',
            style: GoogleFonts.cairo(color: AppColors.lightCream),
          ),
        ],
      ),
    );
  }
}

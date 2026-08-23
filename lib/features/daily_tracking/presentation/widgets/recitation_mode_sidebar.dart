import 'package:shafeea_teach/core/l10n/app_strings.dart';
// lib/features/daily_tracking/presentation/widgets/recitation_mode_sidebar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shafeea/core/models/tracking_type.dart'; // Using the domain enum
import 'package:shafeea/shared/widgets/recitation_mode_sidebar.dart';

// Import the BLoC and its components
import '../../../../shared/widgets/avatar.dart';
import '../bloc/tracking_session_bloc.dart';

// Import the dialogs we will use later
import 'final_report_dialog.dart';

// Enum to represent the different tracking modes. Using an enum is safer
// and more readable than using strings or integers.
enum TrackingMode { memorize, review, recite, finalReport, back }

/// A fixed side navigation bar for the Quran reader screen.
///
/// This widget is stateless and driven entirely by the [TrackingSessionBloc].
/// It displays different tracking modes and dispatches events upon user interaction.
class RecitationSideBar extends StatelessWidget {
  const RecitationSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingSessionBloc, TrackingSessionState>(
      buildWhen: (previous, current) =>
          previous.currentTaskType != current.currentTaskType,
      builder: (context, state) {
        final selectedType = state.currentTaskType;
        return RecitationModeSideBar(
          title: AppStrings.str_teach_rem_263_5f0f,
          avatar: Avatar(size: Size(100, 100)),
          items: [
            CustomModeIconButton(
              icon: Icons.bookmark_add,
              label: TrackingType.memorization.labelAr,
              isSelected: selectedType == TrackingType.memorization,
              onTap: () {
                Navigator.of(context).pop();
                context.read<TrackingSessionBloc>().add(
                  const TaskTypeChanged(newType: TrackingType.memorization),
                );
              },
            ),
            CustomModeIconButton(
              icon: Icons.menu_book,
              label: TrackingType.review.labelAr,
              isSelected: selectedType == TrackingType.review,
              onTap: () {
                Navigator.of(context).pop();
                context.read<TrackingSessionBloc>().add(
                  const TaskTypeChanged(newType: TrackingType.review),
                );
              },
            ),
            CustomModeIconButton(
              icon: Icons.record_voice_over,
              label: TrackingType.recitation.labelAr,
              isSelected: selectedType == TrackingType.recitation,
              onTap: () {
                Navigator.of(context).pop();
                context.read<TrackingSessionBloc>().add(
                  const TaskTypeChanged(newType: TrackingType.recitation),
                );
              },
            ),

            CustomModeIconButton(
              icon: Icons.video_call,
              label: AppStrings.str_teach_rem_264_7276,
              isSelected: false,
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Trigger WebRTC Call Accept/Join here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.str_teach_rem_265_d2c5)),
                );
              },
            ),
            CustomModeIconButton(
              icon: Icons.assessment,
              label: AppStrings.str_teach_rem_79_adaf,
              isSelected: false,
              onTap: () {
                // Action to show the final report dialog
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) {
                    final bloc = context.read<TrackingSessionBloc>();
                    return BlocProvider.value(
                      value: bloc,
                      child: const FinalReportDialog(),
                    );
                  },
                );
              },
            ),
            CustomModeIconButton(
              icon: Icons.arrow_back,
              label: AppStrings.str_teach_rem_266_811c,
              isSelected: false,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

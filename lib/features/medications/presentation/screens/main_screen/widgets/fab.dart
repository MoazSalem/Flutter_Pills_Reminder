import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/edit_medication_screen.dart';

class Fab extends StatelessWidget {
  final ColorScheme theme;
  const Fab({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: theme.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppSizes.circularRadius),
        ),
      ),
      onPressed: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => const EditMedicationScreen(),
      ),
      child: const Icon(Icons.add),
    );
  }
}

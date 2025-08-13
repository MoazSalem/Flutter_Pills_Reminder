import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 10,
          width: 40,
          decoration: BoxDecoration(
            color: isActive
                ? theme.primaryFixedDim
                : theme.onSurface.withAlpha(100),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.primaryFixedDim,
              width: AppSizes.borderWidth,
            ),
          ),
        );
      }),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

Future<void> showModuleInfoSheet(
  BuildContext context, {
  required IconData icon,
  required String heading,
  required String title,
  required String message,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.of(sheetContext).viewPadding.bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, math.max(16.0, bottomInset)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Icon(icon, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.45,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    },
  );
}

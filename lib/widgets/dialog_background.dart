import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DismissDialogIntent extends Intent {
  const DismissDialogIntent();
}

class DialogBackground extends StatelessWidget {
  const DialogBackground({
    super.key,
    required this.onDismiss,
    required this.child,
  });

  final VoidCallback? onDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const DismissDialogIntent(),
      },
      child: Actions(
        actions: {
          DismissDialogIntent: CallbackAction<DismissDialogIntent>(
            onInvoke: (intent) {
              onDismiss?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDismiss,
          child: ColoredBox(
            color: colorScheme.scrim.withValues(alpha: 0.6),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

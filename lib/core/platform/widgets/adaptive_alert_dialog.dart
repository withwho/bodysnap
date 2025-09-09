import 'package:bodysnap/core/platform/platform_style_provider.dart'
    show isCupertinoProvider;
import 'package:bodysnap/core/util/app_log.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show ProviderScope;

Future<void> showAdaptiveAlertDialog({
  required BuildContext context,
  String? title,
  String? message,
  String? confirmText,
  String? cancelText,
  VoidCallback? confirmPress,
  VoidCallback? cancelPress,
  bool isDestructiveAction = false,
}) {
  assert(
    confirmPress != null || cancelPress != null,
    'Either confirmPress or cancelPress must be provided.',
  );
  assert(
    title != null || message != null,
    'Either title or message must be provided.',
  );

  void popThen(BuildContext dialogContext, VoidCallback? cb) {
    Navigator.of(dialogContext, rootNavigator: true).pop();
    cb?.call();
  }

  final isCupertino = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(isCupertinoProvider);

  if (isCupertino) {
    AppLog.d('Cupertino Dialog');
    return showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: message == null ? null : Text(message),
        actions: [
          if (cancelPress != null)
            CupertinoDialogAction(
              onPressed: () => popThen(dialogContext, cancelPress),
              child: Text(cancelText ?? dialogContext.l10n.common_cancel),
            ),
          if (confirmPress != null)
            CupertinoDialogAction(
              isDestructiveAction: isDestructiveAction,
              onPressed: () => popThen(dialogContext, confirmPress),
              child: Text(confirmText ?? dialogContext.l10n.common_confirm),
            ),
        ],
      ),
    );
  }

  AppLog.d('Material Dialog');
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final cs = Theme.of(dialogContext).colorScheme;
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: message == null ? null : Text(message),
        actions: [
          if (cancelPress != null || cancelText != null)
            TextButton(
              onPressed: () => popThen(dialogContext, cancelPress),
              child: Text(cancelText ?? dialogContext.l10n.common_cancel),
            ),
          if (confirmPress != null || confirmText != null)
            FilledButton(
              style: isDestructiveAction
                  ? FilledButton.styleFrom(
                      backgroundColor: cs.error,
                      foregroundColor: cs.onError,
                    )
                  : null,
              onPressed: () => popThen(dialogContext, confirmPress),
              child: Text(confirmText ?? dialogContext.l10n.common_confirm),
            ),
        ],
      );
    },
  );
}

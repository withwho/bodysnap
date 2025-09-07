import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:bodysnap/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<T?> showAdaptiveSheet<T>({
  required BuildContext context,
  required String title,
  String? message,
  required List<({String label, T value, bool selected, bool destructive})>
  options,
}) {
  // 플랫폼 결정: Riverpod 컨테이너에서 isCupertinoProvider 읽기
  final isCupertino = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(isCupertinoProvider);

  if (isCupertino) {
    // ✅ iOS: Cupertino Action Sheet
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(title),
        message: message != null ? Text(message) : null,
        actions: [
          for (final o in options)
            CupertinoActionSheetAction(
              isDestructiveAction: o.destructive,
              onPressed: () => sheetContext.pop<T>(o.value),
              child: Text(o.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => sheetContext.pop<T>(),
          child: Text(context.l10n.common_cancel),
        ),
      ),
    );
  } else {
    // ✅ Android: Material Bottom Sheet
    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(title)),
            const Divider(height: 0),
            for (final o in options)
              ListTile(
                title: Text(
                  o.label,
                  style: o.destructive
                      ? const TextStyle(color: Colors.red)
                      : null,
                ),
                trailing: o.selected ? const Icon(Icons.check) : null,
                onTap: () => sheetContext.pop<T>(o.value),
              ),
            ListTile(
              title: Text(context.l10n.common_cancel),
              onTap: () => sheetContext.pop<T>(),
            ),
          ],
        ),
      ),
    );
  }
}

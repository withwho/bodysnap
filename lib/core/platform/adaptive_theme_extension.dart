import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AdaptiveThemeRefX on WidgetRef {
  // ───────────────────────────────── Common helpers ─────────────────────────────────
  bool get isCupertino => watch(isCupertinoProvider);

  ColorScheme _cs(BuildContext c) => Theme.of(c).colorScheme;
  TextTheme _matText(BuildContext c) => Theme.of(c).textTheme;
  CupertinoTextThemeData _cupText(BuildContext c) =>
      CupertinoTheme.of(c).textTheme;

  Color _resolveCup(BuildContext c, Color color) =>
      color is CupertinoDynamicColor
      ? CupertinoDynamicColor.resolve(color, c)
      : color;

  Color _resolveMat(BuildContext c, Color lightColor, Color darkColor) =>
      Theme.of(c).brightness == Brightness.light ? lightColor : darkColor;

  // ───────────────────────────────── System Colors ─────────────────────────────────
  Color acSystemBlue(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemBlue)
      : _resolveMat(c, Colors.blue, Colors.lightBlue);

  Color acSystemGreen(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemGreen)
      : _resolveMat(c, Colors.green, Colors.lightGreen);

  Color acSystemIndigo(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemIndigo)
      : _resolveMat(c, Colors.indigo, Colors.indigo.shade400);

  Color acSystemOrange(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemOrange)
      : _resolveMat(c, Colors.orange, Colors.orange.shade400);

  Color acSystemPink(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemPink)
      : _resolveMat(c, Colors.pink, Colors.pink.shade400);

  Color acSystemPurple(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemPurple)
      : _resolveMat(c, Colors.purple, Colors.purple.shade400);

  Color acSystemRed(BuildContext c) => isCupertino
    ? _resolveCup(c, CupertinoColors.systemRed)
    : _resolveMat(c, Colors.red, Colors.red.shade400);

  Color acSystemTeal(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemTeal)
      : _resolveMat(c, Colors.teal, Colors.teal.shade400);

  Color acSystemYellow(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemYellow)
      : _resolveMat(c, Colors.yellow, Colors.yellow.shade400);

  // ─────────────────────────────── ColorScheme ───────────────────────────────

  /// 핵심 강조색(주 버튼, 활성 컨트롤, 하이라이트)
  Color acPrimary(BuildContext c) =>
      isCupertino ? CupertinoTheme.of(c).primaryColor : _cs(c).primary;

  /// 카드/시트/컨테이너 표면 기본 배경
  Color acSurface(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemBackground)
      : _cs(c).surface;

  Color acSurfaceSecondary(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.secondarySystemBackground)
      : _cs(c).surfaceContainerLow;

  Color acSurfaceTertiary(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.tertiarySystemBackground)
      : _cs(c).surfaceContainerHigh;

  /// 기본 테두리/구분선
  Color acOutline(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.separator) : _cs(c).outline;

  /// 에러 강조용 배경(배너/칩)
  Color acErrorContainer(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemRed)
      : _cs(c).errorContainer;

  /// errorContainer 위의 텍스트/아이콘
  Color acOnErrorContainer(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.white)
      : _cs(c).onErrorContainer;

  // ─────────────────────────────── TextColor (Material, Cupertino) ───────────────────────────────
  /// Primary text color ( Cupertino : label, Material : onSurface )
  Color acTextColorPrimaryLabel(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.label) : _cs(c).onSurface;

  /// Secondary text color ( Cupertino : secondaryLabel, Material : onSurfaceVariant)
  Color acTextColorSecondaryLabel(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.secondaryLabel)
      : _cs(c).onSurfaceVariant;

  /// Tertiary text color ( Cupertino : tertiaryLabel, Material : onSurfaceVariant( alpha 0.8 ) )
  Color acTextColorTertiaryLabel(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.tertiaryLabel)
      : _cs(c).onSurfaceVariant.withValues(alpha: .8);

  /// Quaternary text color ( Cupertino : quaternaryLabel, Material : onSurfaceVariant( alpha 0.6 ) )
  Color acTextColorQuaternaryLabel(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.quaternaryLabel)
      : _cs(c).onSurfaceVariant.withValues(alpha: .6);

  // ─────────────────────────────── TextTheme (Material, Cupertino) ───────────────────────────────
  /// material : 22 , cupertino : 21
  TextStyle acTitleTextLarge(BuildContext c) => isCupertino
      ? _cupText(c).navTitleTextStyle.copyWith(fontSize: 21)
      : _matText(c).titleLarge!;

  /// material : 16 , cupertino : 17
  TextStyle acTitleTextMedium(BuildContext c) =>
      isCupertino ? _cupText(c).navTitleTextStyle : _matText(c).titleMedium!;

  /// material : 14 , cupertino : 15
  TextStyle acTitleTextSmall(BuildContext c) => isCupertino
      ? _cupText(
          c,
        ).navTitleTextStyle.copyWith(fontSize: 15, letterSpacing: 0.23)
      : _matText(c).titleSmall!;

  /// material : 22 , cupertino : 21
  TextStyle acTextLarge(BuildContext c, {FontWeight? weight}) => isCupertino
      ? _cupText(c).textStyle.copyWith(fontSize: 21, fontWeight: weight)
      : _matText(c).bodyLarge!.copyWith(
          fontSize: 22,
          letterSpacing: 0,
          fontWeight: weight,
        );

  /// material : 16 , cupertino : 17
  TextStyle acTextMedium(BuildContext c, {FontWeight? weight}) => isCupertino
      ? _cupText(c).textStyle.copyWith(fontWeight: weight)
      : _matText(c).bodyLarge!.copyWith(fontWeight: weight);

  /// material : 14 , cupertino : 15
  TextStyle acTextSmall(BuildContext c, {FontWeight? weight}) => isCupertino
      ? _cupText(c).textStyle.copyWith(
          fontSize: 15,
          letterSpacing: 0.23,
          fontWeight: weight,
        )
      : _matText(c).bodyMedium!.copyWith(fontWeight: weight);

  /// material : 12 , cupertino : 13
  TextStyle acTextTiny(BuildContext c, {FontWeight? weight}) => isCupertino
      ? _cupText(c).textStyle.copyWith(
          fontSize: 13,
          letterSpacing: 0.23,
          fontWeight: weight,
        )
      : _matText(c).bodySmall!.copyWith(fontWeight: weight);

  /// material : 11 , cupertino : 10
  TextStyle acTapLabel(BuildContext c) =>
      isCupertino ? _cupText(c).tabLabelTextStyle : _matText(c).labelSmall!;
}

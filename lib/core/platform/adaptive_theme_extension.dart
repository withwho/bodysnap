import 'package:bodysnap/core/platform/platform_style_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AdaptiveThemeRefX on WidgetRef {
  // ───────────────────────────────── Common helpers ─────────────────────────────────
  bool get isCupertino => watch(isCupertinoProvider);

  ColorScheme _cs(BuildContext c) => Theme.of(c).colorScheme;
  TextTheme _matText(BuildContext c) => Theme.of(c).textTheme;
  CupertinoTextThemeData _cupText(BuildContext c) => CupertinoTheme.of(c).textTheme;

  Color _resolveCup(BuildContext c, Color color) =>
      color is CupertinoDynamicColor ? CupertinoDynamicColor.resolve(color, c) : color;

  // ─────────────────────────────── ColorScheme (Material → Cupertino) ───────────────────────────────

  /// 핵심 강조색(주 버튼, 활성 컨트롤, 하이라이트)
  Color acPrimary(BuildContext c) =>
      isCupertino ? CupertinoTheme.of(c).primaryColor : _cs(c).primary;

  /// primary 위의 텍스트/아이콘 색
  Color acOnPrimary(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.white) : _cs(c).onPrimary;

  /// primary의 톤다운 배경(칩/배지/카드 배경)
  Color acPrimaryContainer(BuildContext c) => isCupertino
      ? CupertinoTheme.of(c).primaryColor.withValues(alpha: 0.12)
      : _cs(c).primaryContainer;

  /// primaryContainer 위의 텍스트/아이콘
  Color acOnPrimaryContainer(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.label) : _cs(c).onPrimaryContainer;

  /// 보조 강조색(서브 액션, 보조 강조 요소)
  Color acSecondary(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.systemGreen) : _cs(c).secondary;

  /// secondary 위의 텍스트/아이콘
  Color acOnSecondary(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.white) : _cs(c).onSecondary;

  /// secondary 톤다운 배경(칩/구분용 카드)
  Color acSecondaryContainer(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemGreen).withValues(alpha: 0.12)
      : _cs(c).secondaryContainer;

  /// secondaryContainer 위의 텍스트/아이콘
  Color acOnSecondaryContainer(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.label) : _cs(c).onSecondaryContainer;

  /// 추가 보조색(상태/정보성 요소)
  Color acTertiary(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.systemTeal) : _cs(c).tertiary;

  /// tertiary 위의 텍스트/아이콘
  Color acOnTertiary(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.white) : _cs(c).onTertiary;

  /// tertiary 톤다운 배경
  Color acTertiaryContainer(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemTeal).withValues(alpha: 0.12)
      : _cs(c).tertiaryContainer;

  /// tertiaryContainer 위의 텍스트/아이콘
  Color acOnTertiaryContainer(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.label) : _cs(c).onTertiaryContainer;

  /// 에러/파괴적 액션 색
  Color acError(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.systemRed) : _cs(c).error;

  /// error 위의 텍스트/아이콘
  Color acOnError(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.white) : _cs(c).onError;

  /// 에러 강조용 배경(배너/칩)
  Color acErrorContainer(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemRed).withValues(alpha: 0.12)
      : _cs(c).errorContainer;

  /// errorContainer 위의 텍스트/아이콘
  Color acOnErrorContainer(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.label) : _cs(c).onErrorContainer;

  /// 카드/시트/컨테이너 표면 기본 배경
  Color acSurface(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.systemBackground) : _cs(c).surface;

  /// surface 위의 기본 텍스트/아이콘
  Color acOnSurface(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.label) : _cs(c).onSurface;

  /// 구분선/칩 배경 등 보조 표면(surfaceVariant deprecated , surfaceContainerHighest 대체)
  Color acSurfaceVariant(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemGroupedBackground)
      : _cs(c).surfaceContainerHighest;

  /// surfaceVariant 위의 보조 텍스트
  Color acOnSurfaceVariant(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.secondaryLabel) : _cs(c).onSurfaceVariant;

  /// 화면 전체 배경
  /// NOTE: Material 3에서 ColorScheme.background는 deprecated.
  ///       권장 대체: surface (또는 필요에 따라 surfaceContainer* 계열)
  Color acBackground(BuildContext c) =>
      isCupertino
          ? _resolveCup(c, CupertinoColors.systemBackground)
          : _cs(c).surface;

  /// 배경 위의 기본 텍스트
  /// NOTE: Material 3에서 ColorScheme.onBackground는 deprecated.
  ///       권장 대체: onSurface
  Color acOnBackground(BuildContext c) =>
      isCupertino
          ? _resolveCup(c, CupertinoColors.label)
          : _cs(c).onSurface;

  /// 가장 연한 그룹 배경(넓은 영역)
  Color acSurfaceContainerLowest(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.secondarySystemGroupedBackground)
      : _cs(c).surfaceContainerLowest;

  /// 연한 그룹 배경(카드/리스트 섹션)
  Color acSurfaceContainerLow(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.tertiarySystemGroupedBackground)
      : _cs(c).surfaceContainerLow;

  /// 기본 그룹 배경
  Color acSurfaceContainer(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.systemGroupedBackground) : _cs(c).surfaceContainer;

  /// 대비 높은 그룹 배경(강조 섹션)
  Color acSurfaceContainerHigh(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemGrey5)
      : _cs(c).surfaceContainerHigh;

  /// 가장 대비 높은 그룹 배경(작은 카드/칩)
  Color acSurfaceContainerHighest(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.systemGrey6)
      : _cs(c).surfaceContainerHighest;

  /// 기본 테두리/구분선
  Color acOutline(BuildContext c) =>
      isCupertino ? _resolveCup(c, CupertinoColors.separator) : _cs(c).outline;

  /// 옅은 테두리/비활성 구분선
  Color acOutlineVariant(BuildContext c) => isCupertino
      ? _resolveCup(c, CupertinoColors.opaqueSeparator)
      : _cs(c).outlineVariant;

  /// 반전 표면(바텀시트 헤더 등 특수 배경)
  Color acInverseSurface(BuildContext c) => isCupertino
      ? _resolveCup(
          c,
          const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFF2F2F7),
            darkColor: Color(0xFF1C1C1E),
          ),
        )
      : _cs(c).inverseSurface;

  /// inverseSurface 위 텍스트/아이콘
  Color acOnInverseSurface(BuildContext c) => isCupertino
      ? _resolveCup(
          c,
          const CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.label,
            darkColor: CupertinoColors.white,
          ),
        )
      : _cs(c).onInverseSurface;

  /// 반전 컨텍스트에서의 primary(링크/강조)
  Color acInversePrimary(BuildContext c) =>
      isCupertino ? CupertinoTheme.of(c).primaryColor : _cs(c).inversePrimary;

  /// 표면 고도감/틴트(머티리얼 엘리베이션 효과)
  Color acSurfaceTint(BuildContext c) =>
      isCupertino ? CupertinoTheme.of(c).primaryColor : _cs(c).surfaceTint;

  /// 그림자 색(카드/시트)
  Color acShadow(BuildContext c) => isCupertino
      ? _resolveCup(
          c,
          const CupertinoDynamicColor.withBrightness(
            color: Color(0x33000000),
            darkColor: Color(0x66000000),
          ),
        )
      : _cs(c).shadow;

  /// 뒷배경 차단(다이얼로그/바텀시트)
  Color acScrim(BuildContext c) =>
      isCupertino ? _resolveCup(c, const Color(0x80000000)) : _cs(c).scrim;

  // ─────────────────────────────── TextTheme (Material → Cupertino) ───────────────────────────────
  // 크기/굵기 변경 없이 "시스템 기본" 유지. Material 슬롯 기준으로 API 통일.

  /// 대형 헤드라인(히어로/대 제목 영역)
  TextStyle acDisplayLarge(BuildContext c) =>
      isCupertino ? _cupText(c).navLargeTitleTextStyle : _matText(c).displayLarge!;

  /// 중형 헤드라인(섹션 대 제목)
  TextStyle acDisplayMedium(BuildContext c) =>
      isCupertino ? _cupText(c).navLargeTitleTextStyle : _matText(c).displayMedium!;

  /// 소형 헤드라인(큰 타이포 강조 텍스트)
  TextStyle acDisplaySmall(BuildContext c) =>
      isCupertino ? _cupText(c).navTitleTextStyle : _matText(c).displaySmall!;

  /// 페이지/화면 타이틀(상단 큰 제목)
  TextStyle acHeadlineLarge(BuildContext c) =>
      isCupertino ? _cupText(c).navLargeTitleTextStyle : _matText(c).headlineLarge!;

  /// 섹션 타이틀(중간 크기 제목)
  TextStyle acHeadlineMedium(BuildContext c) =>
      isCupertino ? _cupText(c).navTitleTextStyle : _matText(c).headlineMedium!;

  /// 카드/위젯 타이틀(작은 제목)
  TextStyle acHeadlineSmall(BuildContext c) =>
      isCupertino ? _cupText(c).navTitleTextStyle : _matText(c).headlineSmall!;

  /// 대 타이틀(툴바/네비게이션 바 타이틀 등)
  TextStyle acTitleLarge(BuildContext c) =>
      isCupertino ? _cupText(c).navTitleTextStyle : _matText(c).titleLarge!;

  /// 중 타이틀(리스트 헤더/폼 그룹 타이틀)
  TextStyle acTitleMedium(BuildContext c) =>
      isCupertino ? _cupText(c).navTitleTextStyle : _matText(c).titleMedium!;

  /// 소 타이틀(보조 제목/캡션성 제목)
  TextStyle acTitleSmall(BuildContext c) =>
      isCupertino ? _cupText(c).tabLabelTextStyle : _matText(c).titleSmall!;

  /// 본문 대(기본 본문, 설명 텍스트)
  TextStyle acBodyLarge(BuildContext c) =>
      isCupertino ? _cupText(c).textStyle : _matText(c).bodyLarge!;

  /// 본문 중(일반 텍스트, 설정 설명)
  TextStyle acBodyMedium(BuildContext c) =>
      isCupertino ? _cupText(c).textStyle : _matText(c).bodyMedium!;

  /// 본문 소(보조 설명, 서브 카피)
  TextStyle acBodySmall(BuildContext c) =>
      isCupertino ? _cupText(c).textStyle : _matText(c).bodySmall!;

  /// 버튼/액션 텍스트(강조된 짧은 라벨)
  TextStyle acLabelLarge(BuildContext c) =>
      isCupertino ? _cupText(c).actionTextStyle : _matText(c).labelLarge!;

  /// 보조 라벨(상태/메타 정보)
  TextStyle acLabelMedium(BuildContext c) =>
      isCupertino ? _cupText(c).actionTextStyle : _matText(c).labelMedium!;

  /// 아주 작은 라벨/탭 라벨
  TextStyle acLabelSmall(BuildContext c) =>
      isCupertino ? _cupText(c).tabLabelTextStyle : _matText(c).labelSmall!;
}

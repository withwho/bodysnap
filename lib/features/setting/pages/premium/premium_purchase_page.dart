import 'package:bodysnap/core/platform/adaptive_theme_extension.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_icon.dart';
import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:bodysnap/features/setting/pages/premium/feature_tile.dart';
import 'package:bodysnap/features/setting/pages/premium/subscribe_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PremiumPurchasePage extends ConsumerWidget {
  const PremiumPurchasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crownColor = ref.acSystemYellow(context);

    return AppScaffold(
      // 상단 좌측은 AppScaffold가 자동 Back 처리
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdaptiveIcon(
                    cupertinoIconData: CupertinoIcons.star_fill,
                    materialIconData: Icons.workspace_premium,
                    size: 72,
                    customColor: crownColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Go Premium Today',
                    textAlign: TextAlign.center,
                    style: ref.acTitleTextLarge(context),
                  ),
                  const SizedBox(height: 24),

                  // features
                  const FeatureTile(
                    title: 'No ads in the app',
                    subtitle: 'Enjoy the app without any limitations',
                  ),
                  const SizedBox(height: 18),
                  const FeatureTile(
                    title: 'Unlimited progress photos',
                    subtitle: 'Add as many progress photos as you want',
                  ),
                  const SizedBox(height: 18),
                  const FeatureTile(
                    title: 'Track 10 new measurements',
                    subtitle:
                        'Body fat %, Muscle mass %, Left biceps, Right biceps, Left forearm, Right forearm, Left Thigh, Right Thigh, Left calf, Right calf',
                  ),
                  const SizedBox(height: 18),
                  SubscribeButton(title: '월 구독', price: '1,500', onTap: (){}),
                  const SizedBox(height: 18),
                  SubscribeButton(title: '연 구독', price: '8,900', onTap: (){}),
                  const SizedBox(height: 18),
                  SubscribeButton(title: '소장', price: '14,900', onTap: (){}),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

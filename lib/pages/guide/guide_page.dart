import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/guide/faq_page.dart';
import 'package:campus_app/pages/guide/mensa_balance_page.dart';
import 'package:campus_app/pages/more/widgets/external_link_button.dart';
import 'package:campus_app/utils/widgets/subpage_button.dart';
import 'package:campus_app/pages/guide/widgets/leitwarte_button.dart';
import 'package:campus_app/pages/guide/widgets/wallet.dart';

class GuidePage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const GuidePage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  List<Widget> faqExpandables = [const LeitwarteButton()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 14 : 0, bottom: 40),
                  child: Text(
                    'Guide',
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                  ),
                ),
                CampusWallet(),
                Expanded(
                  child: ListView(
                    children: [
                      // Future features info
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 30, left: 20, right: 20),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/img/icons/info-message.svg',
                              height: 24,
                              color: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Dieser Bereich wird in zukünftigen Versionen stetig ergänzt und um nützliche Hilfen wie bspw. einen interaktiven Raumfinder erweitert werden.',
                                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LeitwarteButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            // AKAFÖ card balance
                            SubPageButton(
                              title: 'Mensa Guthaben',
                              leadingIconPath: 'assets/img/icons/euro.svg',
                              trailingIconPath: 'assets/img/icons/chevron-right.svg',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MensaBalancePage(),
                                  ),
                                );
                              },
                            ),
                            // Room finder
                            SubPageButton(
                              title: 'Raumfinder',
                              leadingIconPath: 'assets/img/icons/map.svg',
                              trailingIconPath: 'assets/img/icons/chevron-right.svg',
                              onTap: () {},
                              disabled: true,
                            ),
                            // FAQ
                            SubPageButton(
                              title: 'FAQ',
                              leadingIconPath: 'assets/img/icons/help-circle.svg',
                              trailingIconPath: 'assets/img/icons/chevron-right.svg',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FaqPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

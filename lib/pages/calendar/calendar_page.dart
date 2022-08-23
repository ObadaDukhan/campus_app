import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

class CalendarPage extends StatelessWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const CalendarPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: pageExitAnimationKey,
          child: AnimatedEntry(
            key: pageEntryAnimationKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Events', style: TextStyle(fontFamily: 'CircularStd', fontSize: 24)),
                CampusTextField.icon(
                  textFieldController: textFieldController,
                  textFieldText: 'Email',
                  pathToIcon: 'assets/img/icons/mail.svg',
                ),
                CampusButton(
                  text: 'Tap me',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

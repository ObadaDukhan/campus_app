import 'package:campus_app/core/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';

class TicketLoginScreen extends StatefulWidget {
  const TicketLoginScreen({super.key});

  @override
  State<TicketLoginScreen> createState() => _TicketLoginScreenState();
}

class _TicketLoginScreenState extends State<TicketLoginScreen> {
  final TicketRepository ticketRepository = sl<TicketRepository>();
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController submitButtonController = TextEditingController();

  bool showErrorMessage = false;
  String errorMessage = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CampusIconButton(
                    iconPath: 'assets/img/icons/arrow-left.svg',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/img/icons/rub-link.png',
                    color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                        ? Colors.black
                        : Colors.white,
                    width: 80,
                    filterQuality: FilterQuality.high,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  CampusTextField(
                    textFieldController: usernameController,
                    textFieldText: 'RUB LoginID',
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  CampusTextField(
                    textFieldController: passwordController,
                    obscuredInput: true,
                    textFieldText: 'RUB Passwort',
                  ),
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  CampusButton(
                    text: 'Login',
                    onTap: () async {
                      final NavigatorState navigator = Navigator.of(context);

                      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                        setState(() {
                          errorMessage = 'Bitte fülle beide Felder aus!';
                          showErrorMessage = true;
                        });
                        return;
                      }

                      setState(() {
                        showErrorMessage = false;
                        loading = true;
                      });

                      await secureStorage.write(key: 'loginId', value: usernameController.text);
                      await secureStorage.write(key: 'password', value: passwordController.text);

                      try {
                        await ticketRepository.loadTicket();
                        navigator.pop();
                      } catch (e) {
                        if (e is InvalidLoginIDAndPasswordException) {
                          setState(() {
                            errorMessage = 'Falsche LoginID und/oder Passwort!';
                            showErrorMessage = true;
                          });
                        }
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  if (showErrorMessage) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/img/icons/info.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.redAccent,
                            BlendMode.srcIn,
                          ),
                          width: 18,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 3),
                        ),
                        Text(
                          errorMessage,
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                              color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                                  ? Colors.black
                                  : const Color.fromRGBO(184, 186, 191, 1)),
                        ),
                      ],
                    ),
                  ],
                  if (loading) ...[
                    CircularProgressIndicator(
                      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                      color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                      strokeWidth: 3,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

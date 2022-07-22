import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/pages/ecampus/bloc/ecampus_bloc.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcampusUtils extends Utils {
  /// Sends TicketRequestedEvent if 2FA is done else send TOTPCheckRequestedEvent
  void ticketButton(BuildContext context) {
    // update BLoC
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final ecampusBloc = BlocProvider.of<EcampusBloc>(context);
    authBloc.add(TOTPCheckRequestedEvent());

    if (authBloc.state is Authentication2FADoneState) {
      ecampusBloc.add(TicketRequestedEvent());
    }
  }
}

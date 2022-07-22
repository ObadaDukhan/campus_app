import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/pages/ecampus/bloc/ecampus_bloc.dart';
import 'package:campus_app/pages/ecampus/widgets/ticket_page.dart';
import 'package:campus_app/utils/pages/ecampus_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ECampusListWidget extends StatelessWidget {
  const ECampusListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = EcampusUtils();

    return BlocBuilder<EcampusBloc, EcampusState>(
      bloc: BlocProvider.of<EcampusBloc>(context),
      builder: (context, state) {
        if (state is TicketPageState) {
          return TicketPDFViewPage(
            ticket: state.ticket,
          );
        } else if (state is EcampusLoading) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is EcampusError) {
          return ErrorMessage(
            message: utils.mapFailureToMessage(state.failure, context),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ecampus'),
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () => utils.ticketButton(context),
                        child: const Text('Ticket'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

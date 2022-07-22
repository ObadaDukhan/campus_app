import 'package:campus_app/core/authentication/authentication_datasource.dart';
import 'package:campus_app/pages/ecampus/ticket_datasource.dart';
import 'package:dartz/dartz.dart';

class TicketRepository {
  final TicketDatasource ticketDatasource;
  final AuthenticationDatasource authenticationDatasource;

  TicketRepository({
    required this.authenticationDatasource,
    required this.ticketDatasource,
  });

  Future<dynamic> getTicketAsPDF() async {
    final tokenId = await authenticationDatasource.getTokenId();

    if (tokenId == null) {
      return none();
    }

    await ticketDatasource.getIdToken(tokenId);

    return ''; //! remove this line
  }
}

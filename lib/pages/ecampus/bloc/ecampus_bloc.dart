import 'package:bloc/bloc.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/ecampus/ticket_repository.dart';
import 'package:meta/meta.dart';
import 'package:pdfx/pdfx.dart';

part 'ecampus_event.dart';
part 'ecampus_state.dart';

class EcampusBloc extends Bloc<EcampusEvent, EcampusState> {
  final TicketRepository ticketRepository;

  EcampusBloc({
    required this.ticketRepository,
  }) : super(EcampusInitial()) {
    on<TicketRequestedEvent>((event, emit) {
      ticketRepository.getTicketAsPDF();

      final ticket = PdfDocument.openAsset('assets/documents/example.pdf');
      emit(TicketPageState(ticket: ticket));

      //emit(EcampusError(failure: GeneralFailure()));
    });
  }
}

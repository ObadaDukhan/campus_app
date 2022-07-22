part of 'ecampus_bloc.dart';

@immutable
abstract class EcampusState {}

class EcampusInitial extends EcampusState {}

class EcampusLoading extends EcampusState {}

class EcampusError extends EcampusState {
  final Failure failure;

  EcampusError({
    required this.failure,
  });
}

class TicketPageState extends EcampusState {
  final Future<PdfDocument> ticket;

  TicketPageState({
    required this.ticket,
  });
}

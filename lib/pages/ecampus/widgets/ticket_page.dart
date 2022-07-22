import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class TicketPDFViewPage extends StatelessWidget {
  final Future<PdfDocument> ticket;

  const TicketPDFViewPage({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: replace with downloaded ticket pdf
    final pdfController = PdfController(
      document: ticket,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semesterticket'),
      ),
      body: PdfView(
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
        ),
        controller: pdfController,
      ),
    );
  }
}

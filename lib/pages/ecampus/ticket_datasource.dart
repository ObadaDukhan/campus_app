import 'dart:io';

import 'package:campus_app/utils/apis/forgerock_api.dart';
import 'package:campus_app/utils/dio_utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

class TicketDatasource {
  final dio.Dio client;
  final http.Client client2;
  final DioUtils dioUtils;

  TicketDatasource({
    required this.client,
    required this.dioUtils,
    required this.client2,
  });

  Future<dynamic> getIdToken(String tokenId) async {
    // TODO: Cleanup and write API
    const uri =
        'https://tc-eca.ruhr-uni-bochum.de/portal/service/student/ecampus.html';

    dioUtils.setCookieForRequest(
      uri,
      [Cookie(ForgerockAPIConstants.cookieName, tokenId)],
    );

    dioUtils.printCookies(uri);

    final response = await client.get(uri);

    final document = html.parse(response.data);

    //? Why response differs from Postman's response??
    final idToken = document.body!.outerHtml; //.idToken;

    return idToken;
  }
}

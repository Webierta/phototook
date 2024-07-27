import 'query_sent.dart';
import 'server.dart';

abstract class ServerApi {
  final QuerySent querySent;
  //SearchLevel searchLevel;

  ServerApi({required this.querySent});

  bool? authorization;
  Map<String, String>? headers;
  late Server server;

  //SearchLevel? searchLevel = SearchLevel.medium;

  Map<String, dynamic> get queryParameters;

  Uri get uri;
}

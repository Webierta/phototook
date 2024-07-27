import '../../models/server.dart';
import '../../models/server_api.dart';

class UnsplashApi extends ServerApi {
  UnsplashApi({required super.querySent}) {
    super.server = Server.unsplash;
    super.authorization =
        server.apiKey != null && server.apiKey!.isNotEmpty ? true : false;
    super.headers = {
      'Accept-Version': 'v1',
      'Authorization': 'Client-ID ${server.apiKey}',
    };
  }

  @override
  Map<String, dynamic> get queryParameters {
    Map<String, dynamic>? parameters = {'query': querySent.query};
    parameters['page'] = '${querySent.page}';
    //parameters['per_page'] = '${server.items}';
    parameters['per_page'] =
        '${server.getItemsPerPage(querySent.searchLevel.name)}';
    if (querySent.filter?.color != null) {
      parameters['color'] = querySent.filter?.color!.name;
    }
    if (querySent.filter?.orientation != null) {
      parameters['orientation'] = querySent.filter?.orientation!.name;
    }
    return parameters;
  }

  @override
  Uri get uri {
    final baseUrl = Uri.parse(server.host);
    return baseUrl.replace(
      path: server.endPoint,
      queryParameters: queryParameters,
    );
  }
}

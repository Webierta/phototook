import '../../models/filter_request.dart';
import '../../models/server.dart';
import '../../models/server_api.dart';

class OpenverseApi extends ServerApi {
  OpenverseApi({required super.querySent}) {
    super.server = Server.openverse;
    super.authorization = true;
    //server.apiKey != null && server.apiKey!.isNotEmpty ? true : false;
    super.headers = {
      'Accept-Version': 'v1',
      'Content-Type': 'application/json',
      'name': 'webierta',
      'description':
          'Meta search for photos in the best image banks. Free open source software',
      'email': "webierta@gmail.com"
    };
  }

  @override
  Map<String, dynamic> get queryParameters {
    Map<String, dynamic>? parameters = {'q': querySent.query};
    parameters['page'] = '${querySent.page}';
    //parameters['page_size'] = '${server.items}';
    //parameters['page_size'] = '${server.items}';
    parameters['page_size'] =
        '${server.getItemsPerPage(querySent.searchLevel.name)}';
    parameters['category'] = 'photograph';
    if (querySent.filter?.orientation != null) {
      var filterOrientationName = switch (querySent.filter!.orientation!) {
        OrientationFilter.landscape => 'tall',
        OrientationFilter.portrait => 'wide',
        OrientationFilter.squarish => 'square',
      };
      parameters['aspect_ratio'] = filterOrientationName;
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

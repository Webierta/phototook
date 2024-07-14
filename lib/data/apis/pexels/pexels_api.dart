import '../../models/filter_request.dart';
import '../../models/server.dart';
import '../../models/server_api.dart';

class PexelsApi extends ServerApi {
  PexelsApi({required super.querySent}) {
    super.server = Server.pexels;
    super.authorization =
        server.apiKey != null && server.apiKey!.isNotEmpty ? true : false;
    super.headers = {
      'Authorization': '${server.apiKey}',
    };
  }

  @override
  Map<String, dynamic> get queryParameters {
    Map<String, dynamic>? parameters = {'query': querySent.query};
    parameters['page'] = '${querySent.page}';
    parameters['per_page'] = '${server.items}';
    if (querySent.filter?.color != null) {
      var hexColor =
          '#${querySent.filter?.color!.color.value.toRadixString(16).substring(2)}';
      parameters['color'] = hexColor;
    }
    if (querySent.filter?.orientation != null) {
      var filterOrientationName =
          querySent.filter!.orientation == OrientationFilter.squarish
              ? 'square'
              : querySent.filter!.orientation!.name;
      parameters['orientation'] = filterOrientationName;
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

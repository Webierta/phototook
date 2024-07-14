import '../../models/filter_request.dart';
import '../../models/server.dart';
import '../../models/server_api.dart';

class PixabayApi extends ServerApi {
  PixabayApi({required super.querySent}) {
    super.server = Server.pixabay;
    super.authorization =
        server.apiKey != null && server.apiKey!.isNotEmpty ? true : false;
    super.headers = {};
  }

  @override
  Map<String, dynamic> get queryParameters {
    Map<String, dynamic>? parameters = {
      'key': server.apiKey,
      'q': querySent.query
    };
    parameters['page'] = '${querySent.page}';
    parameters['per_page'] = '${server.items}';
    parameters['image_type'] = 'photo';
    if (querySent.filter != null && querySent.filter?.color != null) {
      String nameColor = switch (querySent.filter!.color) {
        ColorFilter.magenta => 'pink',
        ColorFilter.purple => 'lilac',
        ColorFilter.teal => 'turquoise',
        _ => querySent.filter!.color!.name,
      };
      parameters['colors'] = nameColor;
    }
    if (querySent.filter?.orientation != null) {
      var filterOrientationName = switch (querySent.filter!.orientation) {
        OrientationFilter.landscape => 'horizontal',
        OrientationFilter.portrait => 'vertical',
        _ => 'all',
      };
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

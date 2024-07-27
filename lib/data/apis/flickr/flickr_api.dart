import '../../models/server.dart';
import '../../models/server_api.dart';

class FlickrApi extends ServerApi {
  FlickrApi({required super.querySent}) {
    super.server = Server.flickr;
    super.authorization =
        server.apiKey != null && server.apiKey!.isNotEmpty ? true : false;
    super.headers = {
      'Content-Type': 'application/json',
    };
  }

  @override
  Map<String, dynamic> get queryParameters {
    Map<String, dynamic>? parameters = {
      'method': 'flickr.photos.search',
      'api_key': '${server.apiKey}'
    };
    parameters['text'] = querySent.query;
    parameters['tags'] = querySent.query;
    parameters['page'] = '${querySent.page}';
    //parameters['per_page'] = '${server.items}';
    parameters['per_page'] =
        '${server.getItemsPerPage(querySent.searchLevel.name)}';
    parameters['content_types'] = '0'; // photos
    parameters['media'] = 'photos';
    parameters['extras'] =
        'original_format, owner_name, icon_server, license, url_t, url_c, url_b, url_o';
    parameters['format'] = 'json';
    parameters['nojsoncallback'] = '1';

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

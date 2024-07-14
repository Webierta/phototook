import 'package:flutter_dotenv/flutter_dotenv.dart';

class UnsplashDownload {
  final String id;

  late bool authorization;
  late Map<String, String> headers;
  late String endPoint;

  static const String host = 'https://api.unsplash.com/';

  UnsplashDownload({required this.id}) {
    String? accessKey = dotenv.maybeGet('AccessKeyUnsplash', fallback: null);
    authorization = accessKey != null && accessKey.isNotEmpty ? true : false;
    endPoint = '/photos/$id/download';
    headers = {
      'Accept-Version': 'v1',
      'Authorization': 'Client-ID $accessKey',
    };
  }

  Uri get uriDownload {
    final baseUrl = Uri.parse(host);
    return baseUrl.replace(path: endPoint);
  }
}

class Download {
  String url;
  Download({required this.url});

  factory Download.fromJson(Map<String, dynamic> json) => Download(
        url: json["url"],
      );
}

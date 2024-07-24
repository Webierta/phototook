import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../apis/flickr/flickr_api.dart';
import '../apis/openverse/openverse_api.dart';
import '../apis/pexels/pexels_api.dart';
import '../apis/pixabay/pixabay_api.dart';
import '../apis/unsplash/unsplash_api.dart';
import 'query_sent.dart';
import 'server_api.dart';

enum Server {
  unsplash(
    url: 'https://unsplash.com/',
    host: 'https://api.unsplash.com/',
    endPoint: 'search/photos',
    key: 'AccessKeyUnsplash',
    items: 30, // 30
  ),
  pexels(
    url: 'https://www.pexels.com',
    host: 'https://api.pexels.com/',
    endPoint: 'v1/search',
    key: 'APIKeyPexels',
    items: 80, // 80,
  ),
  flickr(
    url: 'https://www.flickr.com',
    host: 'https://www.flickr.com',
    endPoint: 'services/rest/',
    key: 'APIFlickrClave',
    items: 500, // 500
  ),
  pixabay(
    url: 'https://pixabay.com/',
    host: 'https://pixabay.com/',
    endPoint: 'api',
    key: 'APIKeyPixabay',
    items: 200, // 3 - 200
  ),
  openverse(
    url: 'https://openverse.org',
    host: 'https://api.openverse.org',
    endPoint: 'v1/images',
    key: 'APIKeyOpenverse',
    items: 20, // 20
  ),
  ;

  final String url;
  final String host;
  final String endPoint;
  final String key;
  final int items;

  const Server({
    required this.url,
    required this.host,
    required this.endPoint,
    required this.key,
    required this.items,
  });

  String? get apiKey => dotenv.maybeGet(key, fallback: null);

  ServerApi getServerApi(QuerySent querySent) {
    return switch (this) {
      unsplash => UnsplashApi(querySent: querySent),
      pexels => PexelsApi(querySent: querySent),
      flickr => FlickrApi(querySent: querySent),
      pixabay => PixabayApi(querySent: querySent),
      openverse => OpenverseApi(querySent: querySent),
    };
  }
}

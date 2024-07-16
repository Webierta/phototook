import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Server {
  unsplash(
    url: 'https://unsplash.com/',
    host: 'https://api.unsplash.com/',
    endPoint: 'search/photos',
    key: 'AccessKeyUnsplash',
    items: 10, // 30
  ),
  pexels(
    url: 'https://www.pexels.com',
    host: 'https://api.pexels.com/',
    endPoint: 'v1/search',
    key: 'APIKeyPexels',
    items: 10, // 80,
  ),
  flickr(
    url: 'https://www.flickr.com',
    host: 'https://www.flickr.com',
    endPoint: 'services/rest/',
    key: 'APIFlickrClave',
    items: 10, // 500
  ),
  pixabay(
    url: 'https://pixabay.com/',
    host: 'https://pixabay.com/',
    endPoint: 'api',
    key: 'APIKeyPixabay',
    items: 10, // 3 - 200
  ),
  openverse(
    url: 'https://openverse.org',
    host: 'https://api.openverse.org',
    endPoint: 'v1/images',
    key: 'APIKeyOpenverse',
    items: 10, // 20
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
}

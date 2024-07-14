import 'server.dart';

abstract class Photo {
  final Server server;
  final String id;
  final int width;
  final int height;
  final String author;
  final String url;
  final String? authorUrl;
  final String? authorImage;
  final String? urlLD;
  final String? urlMD;
  final String? urlHD;
  final String? link;
  final String? linkDownload;
  final List<String>? tags;
  final String? title;
  final String? description;
  final String? license;
  final String? source;

  Photo({
    required this.server,
    required this.id,
    required this.width,
    required this.height,
    required this.author,
    required this.url,
    this.authorUrl,
    this.authorImage,
    this.urlLD,
    this.urlMD,
    this.urlHD,
    this.link,
    this.linkDownload,
    this.tags,
    this.title,
    this.description,
    this.license,
    this.source,
  });
}

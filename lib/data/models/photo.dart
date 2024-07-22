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
  String? linkDownload;
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

  @override
  bool operator ==(Object other) {
    if (other is! Photo) return false;
    if (server != other.server) return false;
    if (id != other.id) return false;
    if (width != other.width) return false;
    if (height != other.height) return false;
    if (author != other.author) return false;
    if (url != other.url) return false;
    if (authorUrl != other.authorUrl) return false;
    if (authorImage != other.authorImage) return false;
    if (urlLD != other.urlLD) return false;
    if (urlMD != other.urlMD) return false;
    if (urlHD != other.urlHD) return false;
    if (link != other.link) return false;
    if (linkDownload != other.linkDownload) return false;
    if (tags != other.tags) return false;
    if (title != other.title) return false;
    if (description != other.description) return false;
    if (license != other.license) return false;
    if (source != other.source) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(server, id, width, height);
}

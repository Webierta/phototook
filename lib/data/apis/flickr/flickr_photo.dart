import '../../models/photo.dart';
import '../../models/server.dart';

class FlickrPhoto extends Photo {
  FlickrPhoto({
    required super.server,
    required super.id,
    required super.width,
    required super.height,
    required super.author,
    required super.url,
    super.authorUrl,
    super.authorImage,
    super.urlLD,
    super.urlMD,
    super.urlHD,
    super.link,
    super.linkDownload,
    super.tags,
    super.title,
    super.description,
    super.license,
    super.source,
  });

  factory FlickrPhoto.fromJson(Map<String, dynamic> json) {
    var authorName = json["ownername"] ?? 'Unknown';
    var author = json["owner"];
    //var icon = json["iconserver"];
    String? authorUrl =
        author != null ? 'https://www.flickr.com/photos/$author/' : null;

    String? url = json["url_o"] ?? json["url_c"] ?? json["url_t"];
    String? link = json["id"] != null && authorUrl != null
        ? '$authorUrl${json["id"]}'
        : null;

    String? license;
    if (json["license"] != null) {
      var flickrLicense = FlickrLicense.values
          .firstWhere((value) => value.id == json["license"]);
      license = flickrLicense.name;
    }

    return FlickrPhoto(
      server: Server.flickr,
      id: json["id"],
      width: json["width_o"] ?? 450,
      height: json["height_o"] ?? 250,
      author: authorName,
      url: url!,
      authorUrl: authorUrl,
      //authorImage: icon,
      urlLD: json["url_t"],
      urlMD: json["url_w"],
      urlHD: json["url_c"],
      link: link,
      linkDownload: url,
      license: license,
      title: json["title"],
      description: json["title"],
    );
  }
}

enum FlickrLicense {
  cero('0', 'All Rights Reserved'),
  uno('1', 'Attribution-NonCommercial-ShareAlike License'),
  dos('2', 'Attribution-NonCommercial License'),
  tres('3', 'Attribution-NonCommercial-NoDerivs License'),
  cuatro('4', 'Attribution License'),
  cinco('5', 'Attribution-ShareAlike License'),
  seis('6', 'Attribution-NoDerivs License'),
  siete('7', 'No known copyright restrictions'),
  ocho('8', 'United States Government Work'),
  nueve('9', 'Public Domain Dedication (CC0)'),
  diez('10', 'Public Domain Mark');

  final String id;
  final String name;
  //final String url;
  const FlickrLicense(this.id, this.name);
}

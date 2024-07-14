import '../../models/photo.dart';
import '../../models/server.dart';

class PixabayPhoto extends Photo {
  PixabayPhoto({
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

  factory PixabayPhoto.fromJson(Map<String, dynamic> json) {
    String? authorUrl;
    authorUrl = json["user"] != null && json["user_id"] != null
        ? 'https://pixabay.com/users/${json["user"]}-${json["user_id"]}'
        : null;

    return PixabayPhoto(
      server: Server.pixabay,
      id: json["id"].toString(),
      width: json["imageWidth"],
      height: json["imageHeight"],
      url: json["webformatURL"],
      author: json["user"] ?? 'Unknown',
      authorUrl: authorUrl,
      authorImage: json["userImageURL"],
      urlLD: json["previewURL"],
      urlMD: json["webformatURL"],
      urlHD: json["largeImageURL"],
      link: json["pageURL"],
      linkDownload: json["fullHDURL"] ?? json["largeImageURL"],
      tags: (json["tags"] == null || json["tags"]!.isEmpty)
          ? null
          : List<String>.from(json["tags"]!.split(', ')),
    );
  }
}

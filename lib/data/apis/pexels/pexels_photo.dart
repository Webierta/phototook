import '../../models/photo.dart';
import '../../models/server.dart';

class PexelsPhoto extends Photo {
  PexelsPhoto({
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

  factory PexelsPhoto.fromJson(Map<String, dynamic> json) => PexelsPhoto(
        server: Server.pexels,
        id: json["id"].toString(),
        width: json["width"],
        height: json["height"],
        url: Src.fromJson(json["src"]).medium!,
        author: json["photographer"],
        authorUrl: json["photographer_url"],
        title: json["alt"],
        description: json["alt"],
        urlLD: Src.fromJson(json["src"]).small,
        urlMD: Src.fromJson(json["src"]).medium,
        urlHD: Src.fromJson(json["src"]).large,
        link: json["url"],
        linkDownload: Src.fromJson(json["src"]).original,
      );
}

class Src {
  String? original;
  String? large2X;
  String? large;
  String? medium;
  String? small;
  String? portrait;
  String? landscape;
  String? tiny;

  Src({
    this.original,
    this.large2X,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  factory Src.fromJson(Map<String, dynamic> json) => Src(
        original: json["original"],
        large2X: json["large2x"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
        portrait: json["portrait"],
        landscape: json["landscape"],
        tiny: json["tiny"],
      );

  Map<String, dynamic> toJson() => {
        "original": original,
        "large2x": large2X,
        "large": large,
        "medium": medium,
        "small": small,
        "portrait": portrait,
        "landscape": landscape,
        "tiny": tiny,
      };
}

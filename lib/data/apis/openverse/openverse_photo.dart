import '../../models/photo.dart';
import '../../models/server.dart';

class OpenversePhoto extends Photo {
  OpenversePhoto({
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

  factory OpenversePhoto.fromJson(Map<String, dynamic> json) {
    String? license = json["license"] != null && json["license"]!.isNotEmpty
        ? json["license"]!.toUpperCase()
        : null;
    if (license != null &&
        json["license_version"] != null &&
        json["license_version"]!.isNotEmpty) {
      license = '$license ${json["license_version"]!}';
    }

    String? source = json["source"] != null && json["source"]!.isNotEmpty
        ? json["source"]
        : null;
    if (source == null &&
        json["provider"] != null &&
        json["provider"]!.isNotEmpty) {
      source = json["provider"];
    }

    return OpenversePhoto(
      server: Server.openverse,
      id: json["id"],
      width: json["width"],
      height: json["height"],
      url: json["url"],
      author: json["creator"] ?? 'Unknown',
      authorUrl: json["creator_url"],
      urlLD: json["thumbnail"],
      urlMD: json["url"],
      urlHD: json["url"],
      link: json["foreign_landing_url"],
      linkDownload: json["url"],
      description: json["title"],
      title: json["title"],
      license: license,
      source: source,
      tags: List<String>.from(
        json["tags"]!.map((tag) => Tag.fromJson(tag).name),
      ),
    );
  }
}

class Tag {
  String? name;
  dynamic accuracy;
  String? unstableProvider;

  Tag({
    this.name,
    this.accuracy,
    this.unstableProvider,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: json["name"],
        accuracy: json["accuracy"],
        unstableProvider: json["unstable__provider"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "accuracy": accuracy,
        "unstable__provider": unstableProvider,
      };
}

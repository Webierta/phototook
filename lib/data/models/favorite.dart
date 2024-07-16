import 'dart:convert';

import 'photo.dart';
import 'server.dart';

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));

String favoriteToJson(Favorite favorite) => json.encode(favorite.toJson());

Favorite favoriteFromPhoto(Photo photo) => Favorite.fromPhoto(photo);

class Favorite extends Photo {
  Favorite({
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

  factory Favorite.fromPhoto(Photo photo) => Favorite(
        server: photo.server,
        id: photo.id,
        width: photo.width,
        height: photo.height,
        author: photo.author,
        url: photo.url,
        authorUrl: photo.authorUrl,
        authorImage: photo.authorImage,
        urlLD: photo.urlLD,
        urlMD: photo.urlMD,
        urlHD: photo.urlHD,
        link: photo.link,
        linkDownload: photo.linkDownload,
        tags: photo.tags,
        //tags: List.from(elements) photo.tags,
        title: photo.title,
        description: photo.description,
        license: photo.license,
        source: photo.source,
      );

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        server: Server.values.byName(json["server"]),
        id: json["id"],
        width: json["width"],
        height: json["height"],
        author: json["author"],
        url: json["url"],
        authorUrl: json["authorUrl"],
        authorImage: json["authorImage"],
        urlLD: json["urlLD"],
        urlMD: json["urlMD"],
        urlHD: json["urlHD"],
        link: json["link"],
        linkDownload: json["linkDownload"],
        tags: json["tags"]?.split(','),
        title: json["title"],
        description: json["description"],
        license: json["license"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "server": server.name,
        "id": id,
        "width": width,
        "height": height,
        "author": author,
        "url": url,
        "authorUrl": authorUrl,
        "authorImage": authorImage,
        "urlLD": urlLD,
        "urlMD": urlLD,
        "urlHD": urlHD,
        "link": link,
        "linkDownload": linkDownload,
        "tags": tags?.join(','),
        "title": title,
        "description": description,
        "license": license,
        "source": source,
      };
}

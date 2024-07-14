import 'unsplash_photo.dart';

class UnsplashPhotos {
  int? total;
  int? totalPages;
  List<UnsplashPhoto>? results;

  UnsplashPhotos({
    this.total,
    this.totalPages,
    this.results,
  });

  factory UnsplashPhotos.fromJson(Map<String, dynamic> json) => UnsplashPhotos(
        total: json["total"],
        totalPages: json["total_pages"],
        results: json["results"] == null
            ? []
            : List<UnsplashPhoto>.from(
                json["results"]!.map((x) => UnsplashPhoto.fromJson(x))),
      );
}

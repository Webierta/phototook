import 'pexels_photo.dart';

class PexelsPhotos {
  int? totalResults;
  int? page;
  int? perPage;
  List<PexelsPhoto>? photos;
  String? nextPage;

  PexelsPhotos({
    this.totalResults,
    this.page,
    this.perPage,
    this.photos,
    this.nextPage,
  });

  factory PexelsPhotos.fromJson(Map<String, dynamic> json) => PexelsPhotos(
        totalResults: json["total_results"],
        page: json["page"],
        perPage: json["per_page"],
        photos: json["photos"] == null
            ? []
            : List<PexelsPhoto>.from(json["photos"]!
                .map((pexelsPhoto) => PexelsPhoto.fromJson(pexelsPhoto))),
        nextPage: json["next_page"],
      );
}

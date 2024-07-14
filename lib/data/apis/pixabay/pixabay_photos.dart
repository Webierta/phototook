import 'pixabay_photo.dart';

class PixabayPhotos {
  int? total;
  int? totalHits;
  List<PixabayPhoto>? hits;

  PixabayPhotos({this.total, this.totalHits, this.hits});

  factory PixabayPhotos.fromJson(Map<String, dynamic> json) => PixabayPhotos(
        total: json["total"],
        totalHits: json["totalHits"],
        hits: json["hits"] == null
            ? []
            : List<PixabayPhoto>.from(
                json["hits"]!.map((x) => PixabayPhoto.fromJson(x))),
      );
}

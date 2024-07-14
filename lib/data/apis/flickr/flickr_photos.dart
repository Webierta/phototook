import 'flickr_photo.dart';

class FlickrJson {
  FlickrPhotos? photos;
  String? stat;
  FlickrJson({this.photos, this.stat});

  factory FlickrJson.fromJson(Map<String, dynamic> json) => FlickrJson(
        photos: json["photos"] == null
            ? null
            : FlickrPhotos.fromJson(json["photos"]),
        stat: json["stat"],
      );
}

class FlickrPhotos {
  int? page;
  int? pages;
  int? perpage;
  int? total;
  List<FlickrPhoto>? photo;

  FlickrPhotos({
    this.page,
    this.pages,
    this.perpage,
    this.total,
    this.photo,
  });

  factory FlickrPhotos.fromJson(Map<String, dynamic> json) => FlickrPhotos(
        page: json["page"],
        pages: json["pages"],
        perpage: json["perpage"],
        total: json["total"],
        photo: json["photo"] == null
            ? []
            : List<FlickrPhoto>.from(
                json["photo"]!.map((x) => FlickrPhoto.fromJson(x))),
      );
}

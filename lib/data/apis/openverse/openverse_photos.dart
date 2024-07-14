import 'openverse_photo.dart';

class OpenversePhotos {
  int? resultCount;
  int? pageCount;
  int? pageSize;
  int? page;
  List<OpenversePhoto>? results;

  OpenversePhotos({
    this.resultCount,
    this.pageCount,
    this.pageSize,
    this.page,
    this.results,
  });

  factory OpenversePhotos.fromJson(Map<String, dynamic> json) =>
      OpenversePhotos(
        resultCount: json["result_count"],
        pageCount: json["page_count"],
        pageSize: json["page_size"],
        page: json["page"],
        results: json["results"] == null
            ? []
            : List<OpenversePhoto>.from(
                json["results"]!.map((x) => OpenversePhoto.fromJson(x))),
      );
}

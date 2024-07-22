import 'package:phototook/data/models/filter_request.dart';

import 'photo.dart';

class QuerySent {
  final String query;
  final int page;
  FilterRequest? filter;
  Photo? photo;

  QuerySent({
    required this.query,
    required this.page,
    this.filter,
    this.photo,
  });
}

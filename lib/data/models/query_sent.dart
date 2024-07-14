import 'package:phototook/data/models/filter_request.dart';

class QuerySent {
  final String query;
  final int page;
  FilterRequest? filter;

  QuerySent({required this.query, required this.page, this.filter});
}

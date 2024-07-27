import 'filter_request.dart';
import 'photo.dart';

enum SearchLevel {
  low(0),
  medium(1),
  max(2);

  final int valor;
  const SearchLevel(this.valor);
}

class QuerySent {
  final String query;
  final int page;
  FilterRequest? filter;
  Photo? photo;
  SearchLevel searchLevel;

  QuerySent({
    required this.query,
    required this.page,
    this.filter,
    this.photo,
    this.searchLevel = SearchLevel.medium,
  });
}

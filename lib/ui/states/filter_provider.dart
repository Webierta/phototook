import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/filter_request.dart';

class FilterNotifier extends StateNotifier<FilterRequest> {
  FilterNotifier() : super(const FilterRequest());

  void setFilter(FilterRequest filter) {
    state = filter;
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterRequest>(
  (ref) => FilterNotifier(),
);

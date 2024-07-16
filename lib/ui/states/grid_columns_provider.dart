import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridColumnsNotifier extends StateNotifier<int> {
  GridColumnsNotifier() : super(3);

  void change() {
    state++;
    if (state > 6) {
      state = 1;
    }
  }

  void fit(int columns) {
    state = columns;
  }
}

final gridColumnsProvider = StateNotifierProvider<GridColumnsNotifier, int>(
  (ref) => GridColumnsNotifier(),
);

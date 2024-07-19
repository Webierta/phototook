import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/filter_request.dart';
import '../../states/filter_provider.dart';

class BottomSheetFilter extends ConsumerStatefulWidget {
  const BottomSheetFilter({super.key});
  @override
  BottomSheetFilterState createState() => BottomSheetFilterState();
}

class BottomSheetFilterState extends ConsumerState<BottomSheetFilter> {
  List<bool> selectionsOrientation =
      List.generate(OrientationFilter.values.length, (i) => false);
  OrientationFilter? orientationSelect;
  ColorFilter? colorSelect;

  void resetFilter() {
    setState(() {
      selectionsOrientation =
          List.generate(OrientationFilter.values.length, (i) => false);
      orientationSelect = null;
      colorSelect = null;
    });
    ref.read(filterProvider.notifier).setFilter(
        FilterRequest(orientation: orientationSelect, color: colorSelect));
  }

  @override
  Widget build(BuildContext context) {
    var filter = ref.watch(filterProvider);

    if (filter.orientation != null) {
      int indexOrientation = OrientationFilter.values
          .indexWhere((item) => item == filter.orientation);
      if (indexOrientation != -1) {
        selectionsOrientation[indexOrientation] = true;
      }
    }

    if (filter.color != null) {
      colorSelect = filter.color;
    }

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListTile(
                      title: const Text('Filter by Orientation'),
                      subtitle: ToggleButtons(
                        direction: MediaQuery.of(context).size.width < 400
                            ? Axis.vertical
                            : Axis.horizontal,
                        onPressed: (int index) {
                          for (int buttonIndex = 0;
                              buttonIndex < selectionsOrientation.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              setState(() {
                                selectionsOrientation[buttonIndex] =
                                    !selectionsOrientation[buttonIndex];
                              });
                            } else {
                              setState(() {
                                selectionsOrientation[buttonIndex] = false;
                              });
                            }
                          }
                          int indexTrue = selectionsOrientation
                              .indexWhere((item) => item == true);
                          if (indexTrue == -1) {
                            setState(() => orientationSelect = null);
                          } else {
                            setState(() => orientationSelect =
                                OrientationFilter.values[indexTrue]);
                          }
                          ref
                              .read(filterProvider.notifier)
                              .setFilter(FilterRequest(
                                orientation: orientationSelect,
                                color: colorSelect,
                              ));
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.green[700],
                        selectedColor: Colors.white,
                        fillColor: Colors.green,
                        textStyle: Theme.of(context).textTheme.labelSmall!,
                        //color: Colors.red[400],
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 100,
                          maxWidth: 100,
                        ),
                        isSelected: selectionsOrientation,
                        children: OrientationFilter.values
                            .map((item) => Text(item.name.toUpperCase()))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      title: const Text('Filter by Color'),
                      subtitle: Wrap(
                        //spacing: 2.0,
                        alignment: WrapAlignment.center,
                        children: ColorFilter.values.map(
                          (colorFilter) {
                            return ChoiceChip(
                              label: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xffFDCF09),
                                child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: colorFilter.color),
                              ),
                              selected: colorSelect == colorFilter,
                              selectedColor: Colors.green,
                              showCheckmark: false,
                              labelPadding: const EdgeInsets.all(0),
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(style: BorderStyle.none),
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  colorSelect = selected ? colorFilter : null;
                                });
                                ref
                                    .read(filterProvider.notifier)
                                    .setFilter(FilterRequest(
                                      orientation: orientationSelect,
                                      color: colorSelect,
                                    ));
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: () => resetFilter(),
                    child: const Text('Clear', maxLines: 1),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 4,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok', maxLines: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

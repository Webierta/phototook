import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
                      title: Text(l10n.bottomSheetFilterByOrientation),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                        child: Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: ToggleButtons(
                            /*  direction: MediaQuery.of(context).size.width < 400
                                ? Axis.vertical
                                : Axis.horizontal, */
                            direction: Axis.vertical,
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
                            color: Theme.of(context).colorScheme.onSecondary,
                            selectedBorderColor: Colors.green[700],
                            borderColor:
                                Theme.of(context).colorScheme.onSecondary,
                            borderWidth: 0.2,
                            selectedColor: Colors.white,
                            fillColor: Colors.green,
                            textStyle: Theme.of(context).textTheme.labelMedium!,
                            /* constraints: const BoxConstraints(
                              minHeight: 40.0,
                              minWidth: 100,
                              maxWidth: 100,
                            ), */
                            /* constraints: const BoxConstraints(
                              minWidth: 100,
                            ), */
                            isSelected: selectionsOrientation,
                            children: OrientationFilter.values
                                .map((item) => Text(l10n
                                    .bottomSheetFilterOrientation(item.name)
                                    .toUpperCase()))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      title: Text(l10n.bottomSheetFilterByColor),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Wrap(
                          //spacing: 2.0,
                          alignment: WrapAlignment.center,
                          children: ColorFilter.values.map(
                            (colorFilter) {
                              return ChoiceChip(
                                label: CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: colorFilter.color,
                                  ),
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
                    child: Text(l10n.bottomSheetFilterClean, maxLines: 1),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 4,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.bottomSheetFilterOk, maxLines: 1),
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

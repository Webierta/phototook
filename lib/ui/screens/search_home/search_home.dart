import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phototook/ui/states/settings_provider.dart';

import '../../../data/models/filter_request.dart';
import '../../../data/models/photo.dart';
import '../../../data/models/query_sent.dart';
import '../../../data/models/request_api.dart';
import '../../../utils/consts.dart';
import '../../../utils/globals.dart' as globals;
import '../../states/filter_provider.dart';
import '../../styles/styles_app.dart';
import '../../widgets/pop_menu.dart';
import '../album/album_screen.dart';
import 'bottom_sheet_filter.dart';

class SearchHomeScreen extends ConsumerStatefulWidget {
  const SearchHomeScreen({super.key});
  @override
  SearchHomeScreenState createState() => SearchHomeScreenState();
}

class SearchHomeScreenState extends ConsumerState<SearchHomeScreen> {
  String query = '';
  TextEditingController queryController = TextEditingController();
  String? topicSelect;
  bool isLoading = false;

  late Image imageMain;

  @override
  void initState() {
    imageMain = Image.asset(
      'assets/images/phototook.webp',
      fit: BoxFit.cover,
      errorBuilder: (context, exception, stackTrace) {
        return const SizedBox();
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(imageMain.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  Future<void> searchQuery(FilterRequest filter) async {
    if (query.trim().isEmpty) {
      return;
    }
    setState(() => isLoading = true);
    final querySent = QuerySent(query: query, page: 1, filter: filter);
    var searchLevel = ref.watch(settingsProvider).searchLevel;
    querySent.searchLevel = searchLevel;

    await RequestApi(querySent: querySent)
        .searchPhotos
        .then((List<Photo> fotos) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              AlbumScreen(querySent: querySent, photos: fotos),
        ),
      );
    }).catchError((onError) {
      // REVISAR ??
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      globals.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(l10n.searchHomeError)),
      );
    }).whenComplete(() => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    List<String> topics = l10n.topics.split(':');

    //var settings = ref.watch(settingsProvider);
    var filter = ref.watch(filterProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: StylesApp.gradient(Theme.of(context).colorScheme),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: const Icon(Icons.image_search, size: 42),
                title: const Text(
                  appName,
                  style: TextStyle(fontFamily: fontLogo),
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: PopMenu(),
                  )
                ],
              ),
              body: SafeArea(
                child: CustomScrollView(
                  shrinkWrap: true,
                  /* physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                  ), */
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 0),
                    ),
                    SliverToBoxAdapter(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.height / 1.8
                                : MediaQuery.of(context).size.height / 2.2,
                            width: MediaQuery.of(context).size.width,
                            child: imageMain,
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            //alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: TextField(
                                    controller: queryController,
                                    //autofocus: true,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.5),
                                      //labelText: 'Query',
                                      //helperText: 'Query',
                                      hintText: l10n.searchHomeSearch,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() =>
                                              query = queryController.text);
                                          searchQuery(filter);
                                        },
                                        icon: const CircleAvatar(
                                          child: Icon(Icons.search),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          isScrollControlled: true,
                                          showDragHandle: true,
                                          //useSafeArea: true,
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          builder: (BuildContext context) {
                                            return const BottomSheetFilter();
                                          },
                                        );
                                      },
                                      label: Text(
                                        l10n.searchHomeFilters,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.tune,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    if (filter.orientation != null)
                                      Icon(
                                        filter.orientation!.icon,
                                        color: Colors.black87,
                                      ),
                                    if (filter.orientation != null &&
                                        filter.color != null)
                                      const SizedBox(width: 4),
                                    if (filter.color != null)
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: filter.color!.color,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: true,
                      //child: TagsCloud(),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.searchHomeByTopic),
                              Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                alignment: WrapAlignment.center,
                                children: topics.map((topic) {
                                  /* if (topics.indexOf(topic) == 0) {
                                    return const SizedBox(width: 0);
                                  } */
                                  return TextButton(
                                    child: Text(topic),
                                    onPressed: () {
                                      queryController.clear();
                                      setState(() => query = topic);
                                      searchQuery(filter);
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

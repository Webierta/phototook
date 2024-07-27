import 'dart:convert';

import 'package:http/http.dart';

import '../../utils/local_storage.dart';
import '../apis/flickr/flickr_api.dart';
import '../apis/flickr/flickr_photos.dart';
import '../apis/openverse/openverse_api.dart';
import '../apis/openverse/openverse_photos.dart';
import '../apis/pexels/pexels_api.dart';
import '../apis/pexels/pexels_photos.dart';
import '../apis/pixabay/pixabay_api.dart';
import '../apis/pixabay/pixabay_photos.dart';
import '../apis/unsplash/unsplash_api.dart';
import '../apis/unsplash/unsplash_photos.dart';
import 'filter_request.dart';
import 'photo.dart';
import 'query_sent.dart';
import 'server.dart';
import 'server_api.dart';

class RequestApi {
  final QuerySent querySent;
  List<Photo> totalPhotos = [];
  late Client client;
  String searchLevel = SearchLevel.medium.name;

  RequestApi({required this.querySent}) : client = Client();
  /* RequestApi({required this.querySent}) {
    client = Client();
  } */

  Future<String> getStorageSearchLevel() async {
    final LocalStorage sharedPrefs = LocalStorage();
    await sharedPrefs.init();
    return sharedPrefs.searchLevel;
  }

  Future<List<Photo>> get searchPhotos async {
    if (querySent.photo?.id != null) {
      var server = querySent.photo?.server;
      List<Photo> photosFromServer =
          await getPhotosFromServer(server!.getServerApi(querySent));
      totalPhotos.addAll(photosFromServer);
      client.close();
      return totalPhotos;
    }

    for (var server in Server.values) {
      if (server == Server.flickr &&
          (querySent.filter?.color != null ||
              querySent.filter?.orientation != null)) {
        continue;
      }
      if (server == Server.pixabay &&
          querySent.filter?.orientation == OrientationFilter.squarish) {
        continue;
      }
      if (server == Server.openverse && querySent.filter?.color != null) {
        continue;
      }

      List<Photo> photosFromServer =
          await getPhotosFromServer(server.getServerApi(querySent));
      totalPhotos.addAll(photosFromServer);
    }

    client.close();
    return totalPhotos;
  }

  Future<List<Photo>> getPhotosFromServer(ServerApi serverApi) async {
    //print('START ${serverApi.server.name}');
    List<Photo> photos = [];
    if (serverApi.authorization == false) {
      return photos;
    }
    Response response;
    try {
      response = await client.get(
        serverApi.uri,
        headers: serverApi.headers,
      );
    } catch (e) {
      return photos;
    }
    if (response.statusCode != 200) {
      //print('error status code in ${serverApi.server}');
      return photos;
    }
    try {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List<Photo> serverPhotos = switch (serverApi.runtimeType) {
        const (PexelsApi) => PexelsPhotos.fromJson(jsonResponse).photos ?? [],
        const (UnsplashApi) =>
          UnsplashPhotos.fromJson(jsonResponse).results ?? [],
        const (FlickrApi) =>
          FlickrJson.fromJson(jsonResponse).photos?.photo ?? [],
        const (PixabayApi) => PixabayPhotos.fromJson(jsonResponse).hits ?? [],
        const (OpenverseApi) =>
          OpenversePhotos.fromJson(jsonResponse).results ?? [],
        _ => [],
      };
      photos.addAll(serverPhotos);
    } catch (e) {
      //print(e.toString());
      return photos;
    }
    return photos;
  }
}

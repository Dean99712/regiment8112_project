import 'package:googleapis/photoslibrary/v1.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:regiment8112_project/helpers/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GoogleAuthentication {
  final List<String> scopes = ['email', PhotosLibraryApi.photoslibraryScope];

  Future<auth.AccessCredentials> createAuthorizedClient() async {
    var client = await auth.clientViaUserConsent(
        ClientId(clientid, clientSecret), scopes, _userPrompt);
    return client.credentials;
  }

  _userPrompt(String url) {
    launchUrlString(url);
  }

  Future<void> listOfPhotos() async {
    final credentials = await createAuthorizedClient();

    final httpClient = http.Client();
    final authClient =
        auth.autoRefreshingClient(ClientId(clientid), credentials, httpClient);

    final photos = PhotosLibraryApi(authClient);

    final albumsResponse = await photos.albums.list();
    if (albumsResponse.albums != null) {
      for (var album in albumsResponse.albums!) {
        print(album.title);
      }
    }
  }
}

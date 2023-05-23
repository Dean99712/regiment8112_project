import 'package:googleapis/photoslibrary/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:regiment8112_project/helpers/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PhotoService {
  final List<String> _scopes = [
    PhotosLibraryApi.photoslibraryScope,
  ];

  Future<AuthClient> getHttpClient() async {
    AuthClient authClient =
        await clientViaUserConsent(ClientId(clientid), _scopes, _userPrompt);
    return authClient;
  }

  getPhotos() async{
    AuthClient client = await getHttpClient();
    var token = await client.get(Uri.parse("https://photoslibrary.googleapis.com/v1/mediaItems"));
    print(token);
  }

  _userPrompt(String url) {
    launchUrlString(url);
  }
}

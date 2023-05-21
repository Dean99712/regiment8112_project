// import 'package:googleapis/photoslibrary/v1.dart' as photos;
// import 'package:google_sign_in/google_sign_in.dart';
//
// GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/photoslibrary.readonly']);
//
// Future<void> signInWithGoogle() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print('Error signing in with Google: $error');
//   }
// }
//
// Future<void> fetchAlbums() async {
//   if (_googleSignIn.currentUser == null) {
//     print('User is not authenticated.');
//     return;
//   }
//
//   final httpClient = await _googleSignIn.();
//   final photosApi = photos.PhotosLibraryApi(httpClient);
//
//   try {
//     final response = await photosApi.albums.list();
//     final albums = response.albums;
//     print(albums);
//   } catch (error) {
//     print('Error fetching albums: $error');
//   }
// }


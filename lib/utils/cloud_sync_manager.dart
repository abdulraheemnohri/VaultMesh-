import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:flutter_dropbox/flutter_dropbox.dart';
import 'package:onedrive/onedrive.dart';

class CloudSyncManager {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.scopes([
    drive.DriveApi.driveScope,
  ]);

  static final DropboxClient _dropboxClient = DropboxClient(
    DropboxApi.fromAppKey("YOUR_DROPBOX_APP_KEY"),
  );

  static final Encrypter _encrypter = Encrypter(AES(Key.fromUtf8('32-length-secret-key...')));

  // Google Drive پر بیکاپ اپ لوڈ کرنا
  static Future<void> uploadToGoogleDrive(String fileName, String data) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final auth.AuthHeaders headers = await account!.authHeaders;
      final drive.DriveApi driveApi = drive.DriveApi(headers);

      final encryptedData = _encrypter.encrypt(data).base64;
      final driveFile = drive.File();
      driveFile.name = '$fileName.vaultx';
      final media = drive.Media(Stream.fromIterable([encryptedData.codeUnits]), encryptedData.length);

      await driveApi.files.create(driveFile, uploadMedia: media);
    } catch (e) {
      print("Error uploading to Google Drive: $e");
    }
  }

  // Dropbox پر بیکاپ اپ لوڈ کرنا
  static Future<void> uploadToDropbox(String fileName, String data) async {
    try {
      await _dropboxClient.authenticate();
      final encryptedData = _encrypter.encrypt(data).base64;
      final file = File('$fileName.vaultx')..writeAsStringSync(encryptedData);

      await _dropboxClient.upload(file, '/$fileName.vaultx');
    } catch (e) {
      print("Error uploading to Dropbox: $e");
    }
  }

  // OneDrive پر بیکاپ اپ لوڈ کرنا
  static Future<void> uploadToOneDrive(String fileName, String data) async {
    try {
      final client = OneDriveClient("YOUR_ONEDRIVE_CLIENT_ID");
      await client.authenticate();

      final encryptedData = _encrypter.encrypt(data).base64;
      await client.uploadFile('$fileName.vaultx', encryptedData.codeUnits);
    } catch (e) {
      print("Error uploading to OneDrive: $e");
    }
  }

  // کلاؤڈ سے بیکاپ ڈاؤن لوڈ کرنا
  static Future<String?> downloadFromCloud(String fileName, String cloudProvider) async {
    try {
      String encryptedData = '';

      if (cloudProvider == 'google_drive') {
        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        final auth.AuthHeaders headers = await account!.authHeaders;
        final drive.DriveApi driveApi = drive.DriveApi(headers);

        final files = await driveApi.files.list(q: "name='$fileName.vaultx'");
        if (files.files!.isNotEmpty) {
          final media = await driveApi.files.get(files.files!.first.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
          encryptedData = await media.stream!.bytesToString();
        }
      } else if (cloudProvider == 'dropbox') {
        await _dropboxClient.authenticate();
        final file = await _dropboxClient.download('/$fileName.vaultx');
        encryptedData = await file.stream.bytesToString();
      } else if (cloudProvider == 'onedrive') {
        final client = OneDriveClient("YOUR_ONEDRIVE_CLIENT_ID");
        await client.authenticate();
        encryptedData = await client.downloadFile('$fileName.vaultx');
      }

      return _encrypter.decrypt64(encryptedData);
    } catch (e) {
      print("Error downloading from $cloudProvider: $e");
      return null;
    }
  }
}
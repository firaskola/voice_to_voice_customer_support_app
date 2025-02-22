import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      print("Microphone permission granted");
    } else {
      print("Microphone permission denied");
    }
  }

  static Future<bool> isMicrophonePermissionGranted() async {
    var status = await Permission.microphone.status;
    return status.isGranted;
  }
}

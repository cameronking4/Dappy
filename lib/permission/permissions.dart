import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.contacts,
      Permission.camera,
    ].request();

    if (await Permission.contacts.isPermanentlyDenied ) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    openAppSettings();
    }

      if (await Permission.camera.isPermanentlyDenied ) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    openAppSettings();
    }

    if (statuses[Permission.location] == PermissionStatus.granted &&
        statuses[Permission.contacts] == PermissionStatus.granted &&
        statuses[Permission.camera] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

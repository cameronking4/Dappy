import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.contacts,
      Permission.camera,
    ].request();

    if (statuses[Permission.location] == PermissionStatus.granted &&
        statuses[Permission.contacts] == PermissionStatus.granted &&
        statuses[Permission.camera] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

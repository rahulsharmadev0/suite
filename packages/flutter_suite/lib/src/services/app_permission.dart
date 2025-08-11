import 'package:permission_handler/permission_handler.dart';

class BasePermission {
  final Permission permission;
  const BasePermission(this.permission);

  Future<bool> request({bool openAppSettingsIfAnyDenied = true}) async {
    final result = await permission.request();
    if (openAppSettingsIfAnyDenied && result.isDenied) {
      openAppSettings();
    }
    return result.isGranted;
  }

  Future get isGranted async => await permission.isGranted;
  Future get isPermanentlyDenied async => await permission.isPermanentlyDenied;
  Future get isDenied async => await permission.isDenied;
  Future get isRestricted async => await permission.isRestricted;
}

/// REQUIRED PERMISSIONS:
/// camera,
/// microphone,
/// location,
/// photos,
/// videos,
/// notification,
abstract class AppPermission {
  const AppPermission();

  static const List<Permission> _requiredPermissions = [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.photos,
    Permission.videos,
    Permission.notification,
  ];

  static BasePermission get camera => const BasePermission(Permission.camera);
  static BasePermission get microphone => const BasePermission(Permission.microphone);
  static BasePermission get location => const BasePermission(Permission.location);
  static BasePermission get photos => const BasePermission(Permission.photos);
  static BasePermission get videos => const BasePermission(Permission.videos);
  static BasePermission get notification => const BasePermission(Permission.notification);

  static Future<bool> requestRequiredPermissions({bool openAppSettingsIfAnyDenied = true}) async {
    final permissionResult = await _requiredPermissions.request();

    if (openAppSettingsIfAnyDenied) {
      for (var p in permissionResult.values) {
        if (p.isDenied || p.isPermanentlyDenied) {
          return openPermissionSettings();
        }
        if (!p.isGranted) return false;
      }
    }

    return true;
  }

  static Future<bool> isRequiredPermissionsGranted() async {
    for (var p in _requiredPermissions) {
      if (await p.isGranted != true) {
        return false;
      }
    }
    return true;
  }

  static Future<bool> openPermissionSettings() => openAppSettings();
}

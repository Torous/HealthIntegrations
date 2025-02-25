// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

Future<int> fetchStepCountAction() async {
  // Add your function code here!// Global Health instance
  final health = Health();
  await health.configure();
  await health.getHealthConnectSdkStatus();

  // define the types to get
  var types = [
    HealthDataType.STEPS,
  ];
  var permissions = [HealthDataAccess.READ_WRITE];

  bool authorized = await authorize(types, permissions);
  if (authorized) {
    debugPrint("User authorized");

    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    return steps ?? 0;
  } else {
    debugPrint("User not authorized");
    return 0;
  }
}

Future<bool> authorize(
    List<HealthDataType> types, List<HealthDataAccess>? permissions) async {
  await Permission.activityRecognition.request();
  await Permission.location.request();

  final health = Health();

  bool? hasPermissions =
      await health.hasPermissions(types, permissions: permissions);

  bool authorized = false;
  if (!hasPermissions) {
    try {
      authorized =
          await health.requestAuthorization(types, permissions: permissions);
    } catch (error) {
      debugPrint("Exception in authorize: $error");
      return false;
    }
  } else {
    authorized = true;
  }
  return authorized;
}

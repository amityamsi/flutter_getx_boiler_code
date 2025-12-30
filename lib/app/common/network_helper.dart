import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_getx_starter_template/app/common/util/helper.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkHelper {
  // Checks whether the device is connected to the internet.
  static Future<bool> isConnected() async {
    final results = await Connectivity().checkConnectivity();
    printLog("CURRENT NETWORK CONNECTION || $results\n");

    // When NO connection exists → list is empty OR contains ConnectivityResult.none
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }

    // Optionally check actual internet
    return await InternetConnection().hasInternetAccess;
  }

  // Checks approximate internet speed by pinging a reliable host.
  static Future<double> checkSpeed() async {
    try {
      final stopwatch = Stopwatch()..start();
      final result = await InternetAddress.lookup('google.com');
      stopwatch.stop();

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Speed = bytes/time, rough estimate — lower is better (ms)
        return stopwatch.elapsedMilliseconds.toDouble();
      } else {
        return double.infinity;
      }
    } catch (e) {
      return double.infinity;
    }
  }
}

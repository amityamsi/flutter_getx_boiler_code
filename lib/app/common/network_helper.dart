import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_getx_starter_template/app/common/util/helper.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkHelper {
  /// Checks whether the device is connected to the internet.
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    printLog("connectivityResult:--> $connectivityResult");

    if (connectivityResult == ConnectivityResult.none) return false;

    return await InternetConnection().hasInternetAccess;
  }

  /// Checks approximate internet speed by pinging a reliable host.
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

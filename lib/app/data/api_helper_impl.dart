import 'dart:async';
import 'package:flutter_getx_starter_template/app/common/constants.dart';
import 'package:flutter_getx_starter_template/app/common/network_helper.dart';
import 'package:flutter_getx_starter_template/app/common/storage/storage.dart';
import 'package:get/get.dart';
import 'api_helper.dart';

class ApiHelperImpl extends GetConnect with ApiHelper {
  @override
  void onInit() {
    httpClient.baseUrl = Constants.baseUrl;
    httpClient.timeout = Constants.timeout;

    addRequestModifier();

    httpClient.addResponseModifier((request, response) {
      printInfo(
        info: 'Status Code: ${response.statusCode}\n'
            'Data: ${response.bodyString?.toString() ?? ''}',
      );

      return response;
    });
  }

  Future<bool> _validateNetwork() async {
    final connected = await NetworkHelper.isConnected();
    if (!connected) {
      throw Exception("No internet connection. Please check your network.");
    }

    return true;
  }

  void addRequestModifier() {
    httpClient.addRequestModifier<dynamic>((request) {
      if (Storage.hasData(Constants.token)) {
        request.headers['Authorization'] = Storage.getValue(Constants.token);
      }

      printInfo(
        info: 'REQUEST ║ ${request.method.toUpperCase()}\n'
            'url: ${request.url}\n'
            'Headers: ${request.headers}\n'
            'Body: ${request.files?.toString() ?? ''}\n',
      );

      return request;
    });
  }

  @override
  Future<Response<dynamic>> getApi(url) async {
    await _validateNetwork(); // ✅ check before request
    return await get(url);
  }

  @override
  Future<Response<dynamic>> postApi(url, body) async {
    printInfo(info: "url us :-> $url");
    await _validateNetwork(); // ✅ check before request
    return await post(url, body);
  }
}

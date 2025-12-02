import 'package:get/get.dart';
export 'package:flutter_getx_starter_template/app/common/util/extensions.dart';

abstract class ApiHelper {
  static ApiHelper get to => Get.find();

  Future<Response> getApi(String url);
  Future<Response> postApi(String url, body);
}

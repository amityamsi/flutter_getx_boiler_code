import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/app/common/util/initializer.dart';
import 'package:flutter_getx_starter_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'app/common/util/exports.dart' show ScreenUtilInit, AppStrings;
import 'app/common/styles/theme.dart';

void main() {
  Initializer.init(() {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, _) => GetMaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: InitialBindings(),
      ),
    );
  }
}

import 'dart:io';

// ------------------ CASE HELPERS ------------------
String snakeToPascal(String input) {
  return input
      .split('_')
      .where((e) => e.isNotEmpty)
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join();
}

String snakeToUpper(String input) {
  return input.toUpperCase();
}

void main(List<String> args) {
  if (args.isEmpty) {
    print(
      '❌ Usage: dart run bin/gen.dart <module_name> OR dart run bin/gen.dart delete <module_name>',
    );
    exit(1);
  }

  // ------------------ DELETE FLOW ------------------
  if (args.first == 'delete') {
    if (args.length < 2) {
      print('❌ Usage: dart run bin/gen.dart delete <module_name>');
      exit(1);
    }

    final name = args[1];
    final snake = name.toLowerCase();
    final pascal = snakeToPascal(snake);
    final folder = 'lib/app/modules/$snake';

    final dir = Directory(folder);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
      print('🗑️ Deleted folder $folder');
    } else {
      print('⚠️ Folder $folder does not exist');
    }

    _cleanRoutes(pascal, snake);
    exit(0);
  }

  // ------------------ CREATE FLOW ------------------
  final name = args.first;
  final snake = name.toLowerCase();
  final pascal = snakeToPascal(snake);
  final folder = 'lib/app/modules/$snake';

  Directory(folder).createSync(recursive: true);

  // --- Create View ---
  File('$folder/${snake}_view.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '${snake}_controller.dart';
import '${snake}_binding.dart';

class ${pascal}View extends GetView<${pascal}Controller> {
  const ${pascal}View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$pascal')),
      body: const Center(child: Text('$pascal View')),
    );
  }
}
''');

  // --- Create Controller ---
  File('$folder/${snake}_controller.dart').writeAsStringSync('''
import 'package:get/get.dart';

class ${pascal}Controller extends GetxController {
  // TODO: Implement $pascal logic
}
''');

  // --- Create Binding ---
  File('$folder/${snake}_binding.dart').writeAsStringSync('''
import 'package:get/get.dart';
import '${snake}_controller.dart';

class ${pascal}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pascal}Controller>(() => ${pascal}Controller());
  }
}
''');

  _addRoutes(pascal, snake);

  print('✅ Created module at $folder and updated routes');
}

// ------------------ ROUTE MANAGEMENT ------------------
void _addRoutes(String pascal, String snake) {
  final projectName = _getProjectName();
  final routesFile = File('lib/app/routes/app_routes.dart');

  if (routesFile.existsSync()) {
    var content = routesFile.readAsStringSync();

    final routeKey = snakeToUpper(snake);

    // --- Routes ---
    final routesConst = "static const $routeKey = _Paths.$routeKey;";
    if (!content.contains(routesConst)) {
      content = content.replaceFirst(
        RegExp(r'(abstract class Routes\s*{)'),
        'abstract class Routes {\n  $routesConst',
      );
    }

    // --- Paths ---
    final pathsConst = "static const $routeKey = '/$snake';";
    if (!content.contains(pathsConst)) {
      content = content.replaceFirst(
        RegExp(r'(abstract class _Paths\s*{)'),
        'abstract class _Paths {\n  $pathsConst',
      );
    }

    routesFile.writeAsStringSync(content);
    print('✅ Updated app_routes.dart with $pascal');
  }

  // --- app_pages.dart ---
  final pagesFile = File('lib/app/routes/app_pages.dart');
  if (pagesFile.existsSync()) {
    var content = pagesFile.readAsStringSync();

    final importBlock =
        "import 'package:$projectName/app/modules/$snake/${snake}_view.dart';\n"
        "import 'package:$projectName/app/modules/$snake/${snake}_binding.dart';";

    if (!content.contains(importBlock)) {
      content = content.replaceFirst(
        RegExp(r"(import 'package:get/get.dart';)"),
        "import 'package:get/get.dart';\n$importBlock",
      );
    }

    final getPage =
        '''
    GetPage(
      name: Routes.${snakeToUpper(snake)},
      page: () => const ${pascal}View(),
      binding: ${pascal}Binding(),
    ),''';

    if (!content.contains(getPage)) {
      content = content.replaceFirst(
        RegExp(r'static final routes = \[\n'),
        'static final routes = [\n$getPage\n',
      );
    }

    pagesFile.writeAsStringSync(content);
    print('✅ Added GetPage to app_pages.dart');
  }
}

// ------------------ HELPERS ------------------
String _getProjectName() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return 'app';
  final lines = pubspec.readAsLinesSync();
  for (var line in lines) {
    if (line.startsWith('name:')) {
      return line.split(':').last.trim();
    }
  }
  return 'app';
}

void _cleanRoutes(String pascal, String snake) {
  final routesFile = File('lib/app/routes/app_routes.dart');
  if (routesFile.existsSync()) {
    var content = routesFile.readAsStringSync();
    final routeKey = snakeToUpper(snake);

    content = content.replaceAll(
      "static const $routeKey = _Paths.$routeKey;",
      '',
    );
    content = content.replaceAll("static const $routeKey = '/$snake';", '');

    routesFile.writeAsStringSync(content);
    print('🗑️ Removed route from app_routes.dart');
  }

  final pagesFile = File('lib/app/routes/app_pages.dart');
  if (pagesFile.existsSync()) {
    var content = pagesFile.readAsStringSync();

    content = content.replaceAll(
      RegExp(
        r"import 'package:.*/modules/.*/.*_view.dart';\nimport 'package:.*/modules/.*/.*_binding.dart';",
      ),
      '',
    );

    content = content.replaceAll(RegExp(r'GetPage\([\s\S]*?\),'), '');

    pagesFile.writeAsStringSync(content);
    print('🗑️ Removed GetPage from app_pages.dart');
  }
}

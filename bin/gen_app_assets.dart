import 'dart:io';

void main() {
  final assetsDir = Directory('assets');
  final outFile = File('lib/app/constants/app_assets.dart');

  final exts = {'.png', '.jpg', '.jpeg', '.svg', '.webp', '.gif'};
  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE – DO NOT EDIT')
    ..writeln()
    ..writeln('abstract class AppAssets {')
    ..writeln('  /// add app assets here')
    ..writeln();

  for (final e in assetsDir.listSync(recursive: true)) {
    if (e is! File) continue;
    final path = e.path.replaceAll('\\', '/');
    final ext = path.substring(path.lastIndexOf('.'));
    if (!exts.contains(ext)) continue;

    final name = _camel(
      path.replaceFirst('assets/', '').replaceAll('/', '_').replaceAll(ext, ''),
    );

    buffer.writeln("  static const String $name = '$path';");
  }

  buffer.writeln('}');
  outFile.createSync(recursive: true);
  outFile.writeAsStringSync(buffer.toString());

  print('✅ AppAssets updated');
}

String _camel(String input) {
  final cleaned = input.replaceAll(RegExp(r'[-_/]+'), '_');
  final parts = cleaned.split('_');

  return parts.first +
      parts
          .skip(1)
          .where((e) => e.isNotEmpty)
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join();
}

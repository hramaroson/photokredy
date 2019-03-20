import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photokredy_core/photokredy_core.dart';

void main() {
  const MethodChannel channel = MethodChannel('photokredy_core');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PhotokredyCore.platformVersion, '42');
  });
}

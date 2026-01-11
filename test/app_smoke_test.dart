import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    // Required for SQLite in tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App launches successfully', (tester) async {
    await tester.pumpWidget(const MyApp());

    // One pump is enough for smoke test
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

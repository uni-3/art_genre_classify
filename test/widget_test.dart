// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:art_genre_class/main.dart';

void main() {
  testWidgets('dom test', (WidgetTester tester) async {
    // treeの構築
    await tester.pumpWidget(MainApp());

    // 初期画面テスト textがあるwidgetは1つ
    expect(find.text('No Image Choosing'), findsOneWidget);

    // buttonテスト? image読み込んでclassifyする
  });
}

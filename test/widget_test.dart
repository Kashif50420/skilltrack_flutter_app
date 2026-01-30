import 'package:flutter_test/flutter_test.dart';
import 'package:silk_track/main.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SilkTrackApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App title is Silk Track', (WidgetTester tester) async {
    await tester.pumpWidget(const SilkTrackApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.title, 'Silk Track');
  });

  testWidgets('Debug banner is disabled', (WidgetTester tester) async {
    await tester.pumpWidget(const SilkTrackApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.debugShowCheckedModeBanner, false);
  });
}

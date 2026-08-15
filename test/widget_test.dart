import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetlab/main.dart';

void main() {
  testWidgets('kinet app initializes brand title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: KinetApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('kinet'), findsWidgets);
    expect(find.text('by athletes, for athletes'), findsOneWidget);
  });
}

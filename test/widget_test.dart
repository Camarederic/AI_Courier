import 'package:flutter_test/flutter_test.dart';

import 'package:ai_courier/main.dart';

void main() {
  testWidgets('AI Courier запускается', (WidgetTester tester) async {
    await tester.pumpWidget(const AICourierApp());

    expect(find.text('AI Courier'), findsOneWidget);
    expect(find.text('Заказы'), findsOneWidget);
  });
}

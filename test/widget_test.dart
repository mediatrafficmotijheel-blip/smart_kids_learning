import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:smart_kids_learning/app/app.dart';
import 'package:smart_kids_learning/features/progress/services/progress_service.dart';
import 'package:smart_kids_learning/features/settings/services/settings_service.dart';

void main() {
  testWidgets('Home screen renders key tiles', (tester) async {
    final settings = SettingsService();
    final progress = ProgressService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsService>.value(value: settings),
          ChangeNotifierProvider<ProgressService>.value(value: progress),
        ],
        child: const SmartKidsApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(SmartKidsApp), findsOneWidget);
  });
}
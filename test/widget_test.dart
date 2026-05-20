import 'package:flutter_test/flutter_test.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/app/picktory_app.dart';
import 'package:picktory/viewmodels/splash_view_model.dart';

void main() {
  setUp(() {
    ServiceLocator.instance.init();
  });

  testWidgets('Splash screen shows brand and loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PicktoryApp());
    await tester.pump();

    expect(find.text('픽토리'), findsOneWidget);
    expect(find.text('데이터 로딩 중...'), findsOneWidget);

    await tester.pump(SplashViewModel.maxWait + const Duration(milliseconds: 500));
    await tester.pump();
  });
}

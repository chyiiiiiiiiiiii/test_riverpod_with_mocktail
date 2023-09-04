import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

ProviderContainer makeProviderContainer({required List<Override> overrides}) {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);

  return container;
}

class ProviderListener<T> extends Mock {
  void call(T? previous, T? next);
}

/// For flutter_test
extension FinderMatchExtension on Finder {
  void never() => expect(this, findsNothing);
  void once() => expect(this, findsOneWidget);
  void times(int number) => expect(this, findsNWidgets(number));
  void some() => expect(this, findsWidgets);
}

/// For mocktail
extension VerificationCalledExtension on VerificationResult {
  void never() => called(0);
  void once() => called(1);
  void twice() => called(2);
  void threeTimes() => called(3);
  void times(int number) => called(number);
}

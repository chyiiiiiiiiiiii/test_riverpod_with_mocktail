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

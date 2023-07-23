import 'package:test/test.dart';

import 'package:dart_bloc_dependency_manager/dependency_manager.dart';

class MockStateListener extends BaseStateListener {
  bool notified = false;
  Object? lastState;

  void onStateChanged(Object? state) {
    notified = true;
    lastState = state;
  }
}

class MockDependencyManager extends BaseDependencyManager {
  @override
  void notify(Object? state) => listeners
      .whereType<MockStateListener>()
      .forEach((MockStateListener listener) => listener.onStateChanged(state));
}

void main() {
  group('Base Dependency Manager =>', () {
    late MockDependencyManager dependencyManager;

    late MockStateListener listener1;
    late MockStateListener listener2;

    setUp(() {
      dependencyManager = MockDependencyManager();

      listener1 = MockStateListener();
      listener2 = MockStateListener();
    });

    tearDown(() {
      dependencyManager.dispose();
    });

    test('should register listeners to dependency manager.', () {
      expect(dependencyManager.listeners, isEmpty);

      dependencyManager
        ..register(listener1)
        ..register(listener2);

      expect(dependencyManager.listeners, hasLength(2));
      expect(dependencyManager.listeners, contains(listener1));
      expect(dependencyManager.listeners, contains(listener2));
    });

    test('should notify listeners when notify method is called.', () {
      dependencyManager
        ..register(listener1)
        ..register(listener2);

      expect(dependencyManager.listeners, hasLength(2));

      dependencyManager.notify('Test State');

      expect(listener1.notified, isTrue);
      expect(listener1.lastState, equals('Test State'));

      expect(listener2.notified, isTrue);
      expect(listener2.lastState, equals('Test State'));
    });

    test('should unregister listeners from dependency manager.', () {
      dependencyManager
        ..register(listener1)
        ..register(listener2);

      expect(dependencyManager.listeners, hasLength(2));

      dependencyManager.unregister(listener1);

      expect(dependencyManager.listeners, hasLength(1));
      expect(dependencyManager.listeners, isNot(contains(listener1)));
      expect(dependencyManager.listeners, contains(listener2));

      dependencyManager.notify('Test State');

      expect(listener1.notified, isFalse);
      expect(listener2.notified, isTrue);
      expect(listener2.lastState, equals('Test State'));
    });

    test('should dispose dependency manager.', () {
      dependencyManager
        ..register(listener1)
        ..register(listener2);

      expect(dependencyManager.listeners, hasLength(2));

      dependencyManager.dispose();

      expect(dependencyManager.listeners, isEmpty);

      dependencyManager.notify('Test State');

      expect(listener1.notified, isFalse);
      expect(listener2.notified, isFalse);
    });
  });
}

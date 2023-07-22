import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:dart_bloc_dependency_manager/dependency_manager.dart';

void main() {
  final BlocADependencyManager dependencyManagerA = BlocADependencyManager();
  final BlocBDependencyManager dependencyManagerB = BlocBDependencyManager();

  final BlocA blocA = BlocA(dependencyManagerA);
  final BlocB blocB = BlocB(dependencyManagerB);
  final BlocC blocC = BlocC();

  dependencyManagerA
    ..register(blocB)
    ..register(blocC);

  dependencyManagerB.register(blocC);

  blocA.update();
  blocB.update();

  dependencyManagerA.dispose();
  dependencyManagerB.dispose();
}

class BlocA extends Cubit<int> {
  BlocA(this.dependencyManager) : super(0);

  final BaseDependencyManager dependencyManager;

  void update() {
    emit(Random().nextInt(100));

    print('$runtimeType update is called: $state');

    dependencyManager.notify(state);
  }
}

class BlocB extends Cubit<int> implements BlocAStateListener {
  BlocB(this.dependencyManager) : super(0);

  final BaseDependencyManager dependencyManager;

  void update() {
    emit(state + 1);

    print('$runtimeType update is called: $state');

    dependencyManager.notify('$state');
  }

  @override
  void updateBlocAListeners({int? state}) {
    emit(state!);

    print('$runtimeType update is received from BlocAStateListener: $state');
  }
}

class BlocC extends Cubit<String>
    implements BlocAStateListener, BlocBStateListener {
  BlocC() : super('');

  @override
  void updateBlocAListeners({int? state}) {
    emit('$state');

    print('$runtimeType update is received from BlocAStateListener: $state');
  }

  @override
  void updateBlocBListeners({String? state}) {
    emit(state!);

    print('$runtimeType update is received from BlocBStateListener: $state');
  }
}

abstract class BlocAStateListener implements BaseStateListener {
  void updateBlocAListeners({int? state});
}

class BlocADependencyManager extends BaseDependencyManager {
  @override
  void notify(Object? state) => listeners
      .whereType<BlocAStateListener>()
      .forEach((BlocAStateListener listener) =>
          listener.updateBlocAListeners(state: state as int?));
}

abstract class BlocBStateListener implements BaseStateListener {
  void updateBlocBListeners({String? state});
}

class BlocBDependencyManager extends BaseDependencyManager {
  @override
  void notify(Object? state) => listeners
      .whereType<BlocBStateListener>()
      .forEach((BlocBStateListener listener) =>
          listener.updateBlocBListeners(state: state as String?));
}

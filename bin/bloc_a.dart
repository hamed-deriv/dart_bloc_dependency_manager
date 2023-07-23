import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:dart_bloc_dependency_manager/dependency_manager.dart';

class BlocA extends Cubit<int> {
  BlocA(this.dependencyManager) : super(0);

  final BaseDependencyManager dependencyManager;

  void update() {
    emit(Random().nextInt(100));

    print('$runtimeType update is called: $state');

    dependencyManager.notify(state);
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

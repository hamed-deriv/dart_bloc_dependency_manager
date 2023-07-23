import 'package:bloc/bloc.dart';

import 'package:dart_bloc_dependency_manager/dependency_manager.dart';

import 'bloc_a.dart';

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

import 'package:bloc/bloc.dart';

import 'bloc_a.dart';
import 'bloc_b.dart';

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

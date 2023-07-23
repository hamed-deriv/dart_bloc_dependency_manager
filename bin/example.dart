import 'package:dart_bloc_dependency_manager/dependency_manager.dart';

import 'bloc_a.dart';
import 'bloc_b.dart';
import 'bloc_c.dart';

void main() {
  final BaseDependencyManager dependencyManagerA = BlocADependencyManager();
  final BaseDependencyManager dependencyManagerB = BlocBDependencyManager();

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

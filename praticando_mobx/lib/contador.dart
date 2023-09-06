import 'package:mobx/mobx.dart';
part 'contador.g.dart';

class Contador = _Contador with _$Contador;

abstract class _Contador with Store {
  @observable
  int cont = 0;

  @action
  void incrementar() {
    cont++;
  }
}
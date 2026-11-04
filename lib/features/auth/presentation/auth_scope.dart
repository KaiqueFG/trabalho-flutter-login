import 'package:flutter/widgets.dart';

import '../data/auth_repository.dart';

/// Disponibiliza o [AuthRepository] para toda a árvore de widgets
/// (injeção de dependência simples, sem pacotes externos).
class AuthScope extends InheritedWidget {
  const AuthScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final AuthRepository repository;

  static AuthRepository of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope não encontrado na árvore de widgets.');
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) => repository != oldWidget.repository;
}

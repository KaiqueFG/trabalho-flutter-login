import 'package:flutter/widgets.dart';

import '../features/auth/presentation/pages/register_page.dart';

/// Rotas nomeadas. Login e Home são controladas pelo `AuthGate`.
abstract final class AppRoutes {
  static const register = '/cadastro';

  static final Map<String, WidgetBuilder> routes = {
    register: (_) => const RegisterPage(),
  };
}

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../features/auth/presentation/auth_scope.dart';
import 'app_routes.dart';

class App extends StatelessWidget {
  const App({super.key, required this.authRepository});

  static const title = 'Auth Base';

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      repository: authRepository,
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const AuthGate(),
        routes: AppRoutes.routes,
      ),
    );
  }
}

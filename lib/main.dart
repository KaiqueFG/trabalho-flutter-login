import 'package:flutter/material.dart';

import 'app/app.dart';
import 'features/auth/data/local_auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authRepository = await LocalAuthRepository.create();
  runApp(App(authRepository: authRepository));
}

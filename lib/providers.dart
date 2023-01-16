import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/auth/controllers/auth_controller.dart';

/// check if user has logged in
final isLoggedProvider = FutureProvider<bool>(
  (ref) {
    final authController =
        ref.watch(authControllerProvider);
    return authController.isLoggedIn;
  },
);
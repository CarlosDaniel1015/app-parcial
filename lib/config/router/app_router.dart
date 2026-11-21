import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_parcial/config/presentation/screen/login/login_screen.dart';
import 'package:app_parcial/config/presentation/screen/registro/registro_screen.dart';
import 'package:app_parcial/config/presentation/screen/feed/feed_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final String location = state.matchedLocation;
    final bool isAuthRoute = location == '/login' || location == '/registro';

    // Si no hay sesión iniciada, solo se puede acceder al login y al registro
    if (!loggedIn) {
      return isAuthRoute ? null : '/login';
    }

    // Si hay sesión iniciada, se debe ir al feed
    if (loggedIn && isAuthRoute) {
      return '/feed';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'Login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/registro',
      name: 'Registro',
      builder: (context, state) => const RegistroScreen(),
    ),
    GoRoute(
      path: '/feed',
      name: 'Feed',
      builder: (context, state) => const FeedScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Página no encontrada: ${state.error}',
        style: const TextStyle(fontSize: 16),
      ),
    ),
  ),
);

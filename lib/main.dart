import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_parcial/firebase_options.dart';
import 'package:app_parcial/config/router/app_router.dart';
import 'package:app_parcial/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Nota al inicializar Firebase: $e');
  }
  runApp(const AppParcial());
}

class AppParcial extends StatelessWidget {
  const AppParcial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Parcial',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme(selectedColor: 0).getTheme(),
    );
  }
}

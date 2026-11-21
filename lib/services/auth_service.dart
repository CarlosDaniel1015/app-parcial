import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Inicio de sesión con correo y contraseña en Firebase
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw translateFirebaseError(e);
    } catch (e) {
      throw 'Ocurrió un error inesperado al iniciar sesión: $e';
    }
  }

  /// Registro de usuario con correo, contraseña y nombre completo en Firebase
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Guardar nombre completo del usuario
      if (credential.user != null) {
        await credential.user!.updateDisplayName(fullName.trim());
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw translateFirebaseError(e);
    } catch (e) {
      throw 'Ocurrió un error inesperado durante el registro: $e';
    }
  }

  /// Inicio de sesión con Google autenticado en Firebase
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // En google_sign_in v7.x se utiliza GoogleSignIn.instance
        final GoogleSignInAccount googleUser =
            await GoogleSignIn.instance.authenticate();

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw translateFirebaseError(e);
    } catch (e) {
      throw 'Error al iniciar sesión con Google: $e';
    }
  }

  /// Inicio de sesión con Facebook autenticado en Firebase
  Future<UserCredential?> signInWithFacebook() async {
    try {
      if (kIsWeb) {
        final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        return await _auth.signInWithPopup(facebookProvider);
      } else {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
        );

        if (result.status == LoginStatus.success &&
            result.accessToken != null) {
          final OAuthCredential credential = FacebookAuthProvider.credential(
            result.accessToken!.tokenString,
          );
          return await _auth.signInWithCredential(credential);
        } else if (result.status == LoginStatus.cancelled) {
          return null; // El usuario canceló
        } else {
          throw result.message ?? 'Error al autenticar con Facebook';
        }
      }
    } on FirebaseAuthException catch (e) {
      throw translateFirebaseError(e);
    } catch (e) {
      throw 'Error al iniciar sesión con Facebook: $e';
    }
  }

  /// Cerrar sesión en Firebase, Google y Facebook
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}

    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {}

    try {
      if (!kIsWeb) {
        await FacebookAuth.instance.logOut();
      }
    } catch (_) {}
  }

  /// Traducción amigable de errores de Firebase Auth a español
  static String translateFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe ningún usuario registrado con este correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta. Por favor, inténtalo de nuevo.';
      case 'invalid-credential':
        return 'Credenciales incorrectas. Verifica tu correo y contraseña.';
      case 'email-already-in-use':
        return 'El correo ya se encuentra registrado. Inicia sesión o usa otro.';
      case 'weak-password':
        return 'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido inhabilitada. Contacta al soporte.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Inténtalo más tarde.';
      case 'operation-not-allowed':
        return 'Este método de inicio de sesión no está habilitado en Firebase.';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu acceso a internet.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con el mismo correo pero con otro método de acceso.';
      default:
        return e.message ?? 'Error de autenticación (${e.code}).';
    }
  }
}

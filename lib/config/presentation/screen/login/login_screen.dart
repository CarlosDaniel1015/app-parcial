import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_parcial/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _cargando = false;
  String? _errorGlobal;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginEmailPassword() async {
    setState(() => _errorGlobal = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    try {
      await _authService.signInWithEmailAndPassword(
        email: _correoController.text,
        password: _passwordController.text,
      );
      // Redirection is handled reactively by GoRouter!
    } catch (e) {
      if (mounted) {
        setState(() => _errorGlobal = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _onLoginGoogle() async {
    setState(() {
      _errorGlobal = null;
      _cargando = true;
    });
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null && mounted) {
        setState(() => _cargando = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorGlobal = e.toString();
          _cargando = false;
        });
      }
    }
  }

  Future<void> _onLoginFacebook() async {
    setState(() {
      _errorGlobal = null;
      _cargando = true;
    });
    try {
      final credential = await _authService.signInWithFacebook();
      if (credential == null && mounted) {
        setState(() => _cargando = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorGlobal = e.toString();
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isWide = MediaQuery.of(context).size.width > 750;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      body: Row(
        children: [
          if (isWide)
            Expanded(
              flex: 5,
              child: _PanelLateral(colors: colors, textTheme: textTheme),
            ),
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LogoHeader(colors: colors),
                          const SizedBox(height: 32),
                          Text(
                            'Iniciar Sesión',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ingresa tu correo y contraseña para acceder.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Formulario
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _CampoCorreo(
                                  controller: _correoController,
                                  colors: colors,
                                ),
                                const SizedBox(height: 18),
                                _CampoPassword(
                                  controller: _passwordController,
                                  obscure: _obscurePassword,
                                  colors: colors,
                                  onToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                if (_errorGlobal != null) ...[
                                  const SizedBox(height: 14),
                                  _MensajeError(
                                    mensaje: _errorGlobal!,
                                    colors: colors,
                                  ),
                                ],
                                const SizedBox(height: 24),
                                _BotonIngresar(
                                  cargando: _cargando,
                                  onPressed: _onLoginEmailPassword,
                                  colors: colors,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Enlace a Registro
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¿No tienes cuenta? ',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => context.go('/registro'),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      'Regístrate',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          _DivisorOpciones(colors: colors),
                          const SizedBox(height: 20),

                          // Botones de Google y Facebook
                          _BotonSocial(
                            icono: Icons.g_mobiledata,
                            iconWidget: const _GoogleIconWidget(),
                            label: 'Continuar con Google',
                            colorBorde: Colors.grey.shade300,
                            colorFondo: Colors.white,
                            colorTexto: Colors.black87,
                            cargando: _cargando,
                            onPressed: _onLoginGoogle,
                          ),
                          const SizedBox(height: 12),
                          _BotonSocial(
                            icono: Icons.facebook,
                            label: 'Continuar con Facebook',
                            colorBorde: const Color(0xFF1877F2),
                            colorFondo: const Color(0xFF1877F2),
                            colorTexto: Colors.white,
                            cargando: _cargando,
                            onPressed: _onLoginFacebook,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de cabecera con logo
class _LogoHeader extends StatelessWidget {
  final ColorScheme colors;
  const _LogoHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.play_circle_fill_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Parcial',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 19,
                color: colors.onSurface,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'Video Feed & Firebase Auth',
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Campo de Correo Electrónico con validación
class _CampoCorreo extends StatelessWidget {
  final TextEditingController controller;
  final ColorScheme colors;

  const _CampoCorreo({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        hintText: 'nombre@ejemplo.com',
        prefixIcon: Icon(Icons.email_outlined, color: colors.primary),
        filled: true,
        fillColor: colors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'El correo electrónico es obligatorio';
        }
        final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!regex.hasMatch(valor.trim())) {
          return 'Ingresa un formato de correo válido (ej: usuario@correo.com)';
        }
        return null;
      },
    );
  }
}

// Campo de Contraseña con validación
class _CampoPassword extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final ColorScheme colors;
  final VoidCallback onToggle;

  const _CampoPassword({
    required this.controller,
    required this.obscure,
    required this.colors,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: '••••••••',
        prefixIcon: Icon(Icons.lock_outline_rounded, color: colors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: colors.onSurfaceVariant,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: colors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'La contraseña es obligatoria';
        }
        return null;
      },
    );
  }
}

// Mensaje de Error
class _MensajeError extends StatelessWidget {
  final String mensaje;
  final ColorScheme colors;

  const _MensajeError({required this.mensaje, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: colors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                color: colors.onErrorContainer,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botón de Ingresar
class _BotonIngresar extends StatelessWidget {
  final bool cargando;
  final VoidCallback onPressed;
  final ColorScheme colors;

  const _BotonIngresar({
    required this.cargando,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: cargando ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: cargando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

// Separador con texto "o conéctate con"
class _DivisorOpciones extends StatelessWidget {
  final ColorScheme colors;
  const _DivisorOpciones({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'o continuar con',
            style: TextStyle(
              fontSize: 12,
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.outlineVariant)),
      ],
    );
  }
}

// Botón Social (Google / Facebook)
class _BotonSocial extends StatelessWidget {
  final IconData? icono;
  final Widget? iconWidget;
  final String label;
  final Color colorBorde;
  final Color colorFondo;
  final Color colorTexto;
  final bool cargando;
  final VoidCallback onPressed;

  const _BotonSocial({
    this.icono,
    this.iconWidget,
    required this.label,
    required this.colorBorde,
    required this.colorFondo,
    required this.colorTexto,
    required this.cargando,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: cargando ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorFondo,
          side: BorderSide(color: colorBorde),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null)
              iconWidget!
            else if (icono != null)
              Icon(icono, color: colorTexto, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: colorTexto,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIconWidget extends StatelessWidget {
  const _GoogleIconWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}

// Panel Lateral para pantallas amplias
class _PanelLateral extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _PanelLateral({
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
            const Color(0xFF0D47A1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.video_library_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'APP PARCIAL',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Descubre videos\nincreíbles en vertical.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Autenticación segura con Firebase:\n• Correo y Contraseña\n• Google Sign-In\n• Facebook Auth\n\nY un feed dinámico e interactivo estilo TikTok.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ],
          ),
          Text(
            '© 2026 App Parcial - Unitecnar',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

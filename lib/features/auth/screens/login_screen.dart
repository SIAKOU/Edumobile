// login_screen.dart
// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gestion_ecole/core/services/auth_service.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _redirectToDashboardByRole(String userId, {String? fallbackRole}) async {
    String? role = fallbackRole;

    // Toujours essayer de récupérer le rôle le plus récent depuis la table 'users'
    // fallbackRole (venant des métadonnées) peut être utilisé si la requête échoue ou ne retourne rien.
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      role = response?['role'] ?? fallbackRole ?? 'student'; // Priorité à la table, puis metadata, puis défaut
    } catch (e) {
      debugPrint("Erreur lors de la récupération du rôle dans LoginScreen: $e. Utilisation du fallbackRole: $fallbackRole");
      role = fallbackRole ?? 'student'; // En cas d'erreur, utiliser le fallback ou défaut
    }

    switch (role) {
      case 'admin':
        if (mounted) context.goNamed('adminDashboard');
        break;
      case 'teacher':
        if (mounted) context.goNamed('teacherDashboard');
        break;
      case 'student':
      default:
        if (mounted) context.goNamed('studentDashboard');
        break;
    }
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String identifier = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String emailToUse = identifier;

      // Si ce n'est pas un email, on considère que c'est un username
      if (!identifier.contains('@')) {
        final response = await Supabase.instance.client
            .from('users')
            .select('email')
            .eq('full_name', identifier)
            .maybeSingle();
        if (response == null || response['email'] == null) {
          setState(() => _errorMessage = 'Nom d\'utilisateur inconnu');
          setState(() => _isLoading = false);
          return;
        }
        emailToUse = response['email'];
      }

      final response = await _authService.signInWithEmail(
        email: emailToUse,
        password: password,
      );

      final user = response.user;
      final userId = user?.id;
      final role = user?.userMetadata?['role'] ?? '';

      if (userId == null) {
        setState(() => _errorMessage = 'Utilisateur non trouvé');
        return;
      }

      _redirectToDashboardByRole(userId, fallbackRole: role);
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Erreur de connexion: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    await _authService.signInWithGoogle();
    // OAuth flow initiated. Session and navigation will be handled by onAuthStateChange.
  } on AuthException catch (e) {
    if (mounted) setState(() => _errorMessage = e.message);
  } catch (e) {
    if (mounted) setState(() => _errorMessage = 'Erreur Google sign-in: $e');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

Future<void> _loginWithGitHub() async {
  setState(() { _isLoading = true; _errorMessage = null; });

  try {
    await _authService.signInWithGitHub();
    // OAuth flow initiated. Session and navigation will be handled by onAuthStateChange.
  } on AuthException catch (e) {
    if (mounted) setState(() => _errorMessage = e.message);
  } catch (e) {
    if (mounted) setState(() => _errorMessage = 'Erreur GitHub sign-in: $e');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text('login_title'.tr()),
        centerTitle: true,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: locale,
              icon: const Icon(Icons.language),
              items: [
                DropdownMenuItem(
                  value: const Locale('fr'),
                  child: Text('Français', style: theme.textTheme.bodyMedium),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text('English', style: theme.textTheme.bodyMedium),
                ),
              ],
              onChanged: (value) {
                if (value != null) context.setLocale(value);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'login_welcome'.tr(),
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email ou nom d\'utilisateur',
                          hintText: 'Saisir votre email ou nom d\'utilisateur',
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'login_email_required'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'login_password'.tr(),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'login_password_required'.tr()
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null : () => context.goNamed('forgotPassword'), // Utiliser goNamed
                          child: Text('login_forgot_password'.tr()),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Text('login_button'.tr()), // ou "Se connecter"
                        ),
                      ),
                      const SizedBox(height: 24),
// Séparateur avec texte centré
// Séparateur avec texte centré
                      Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "login_or".tr(), // ou "Ou continuer avec"
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 24),
// Boutons sociaux côte à côte
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Image.asset(
                                  'assets/images/icons/google_logo.png',
                                  height: 24),
                              label: const Text("Google"),
                              onPressed: _isLoading ? null : _loginWithGoogle,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.4)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Image.asset(
                                  'assets/images/icons/github_logo.png',
                                  height: 24),
                              label: const Text("Github"),
                              onPressed: _isLoading ? null : _loginWithGitHub,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.4)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("login_no_account".tr()),
                          TextButton( // Assurez-vous que la route 'signup' a un nom dans app_routes.dart
                            onPressed: _isLoading ? null : () => context.goNamed('signup'),
                            child: Text("login_signup".tr()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



Future<void> createDefaultAdmin() async {
  final email = 'SIAKOU2006@gmail.com';
  final password = 'SIAKOU2006';
  final response = await Supabase.instance.client.auth.signUp(
    email: email,
    password: password,
    data: {'role': 'admin', 'full_name': 'SIAKOU'},
  );
  if (response.user != null) {}
}

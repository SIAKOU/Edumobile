/// signup_screen.dart
/// Écran d'inscription pour l'application.
/// Gère la saisie des informations utilisateur, l'affichage des erreurs et la logique d'inscription.
/// Inclut l'inscription par e-mail, Google et GitHub.
/// L'utilisateur choisit entre le rôle "élève" ou "professeur".
/// On ne peut pas créer de compte administrateur ici (réservé à la base de données ou à l'équipe technique).
// ignore_for_file: curly_braces_in_flow_control_structures, unused_element, no_leading_underscores_for_local_identifiers

library;

import 'package:flutter/material.dart';
import 'package:gestion_ecole/core/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gestion_ecole/core/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../app/config/app_routes.dart'; // Assurez-vous que ce chemin est correct pour AppRouteNames
import '../../../core/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupScreen extends StatefulWidget {
  // ApiClient is no longer passed via constructor
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _termsAccepted = false;
  String? _selectedRole; // 'student' or 'teacher'
  final _roles = ['student', 'teacher'];
  late AuthService _authService; // Will be initialized in initState
  // final UserService _userService = UserService(apiClient: di<ApiClient>()); // Assuming UserService needs ApiClient and is used, or get from di
  // final di = GetIt.instance; // If you need to access GetIt instance directly

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // AuthService should ideally get its ApiClient dependency from GetIt itself,
    // or be registered in GetIt and retrieved here.
    _authService = AuthService(); 
  }

  // Helper pour définir le rôle d'un nouvel utilisateur (jamais admin ici !)
  String get _defaultSignupRole => _selectedRole ?? 'student';

  // Simule la sauvegarde d'un UserModel
  // Dans signup_screen.dart, modifiez la méthode _saveUserProfile

  Future<void> _handleAuthResult(AuthResponse response,
      {String? provider}) async {
    // Vérifie si le widget est toujours monté
    if (!mounted) return;

    final user = response.user;
    if (user == null) {
      setState(() => _errorMessage = 'Erreur: Utilisateur non trouvé après authentification.');
      return;
    }

    // Utiliser les métadonnées utilisateur de Supabase Auth si disponibles (surtout pour OAuth)
    // Sinon, utiliser les contrôleurs (pour l'inscription par email)
    String? fullName = user.userMetadata?['full_name'] ?? _nameController.text.trim();
    String? email = user.email; // L'email doit toujours provenir de l'utilisateur authentifié
    String? avatarUrl = user.userMetadata?['avatar_url'];
    String? phone = user.userMetadata?['phone'] ?? _phoneController.text.trim();
    
    // S'assure que l'email n'est pas nul
    email ??= _emailController.text.trim();
    if (email.isEmpty) {
        if (!mounted) return;
        setState(() => _errorMessage = 'Erreur: Email non disponible pour la création du profil.');
        return;
    }

    // L'ID de UserModel DOIT être user.id de Supabase Auth
    final userData = UserModel(
      id: user.id, 
      email: email,
      fullName: fullName!.isNotEmpty ? fullName : null,
      role: _defaultSignupRole,
      phone: phone!.isNotEmpty ? phone : null,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      isActive: true,
      createdAt: DateTime.now(), // Sera écrasé par la BDD si DEFAULT NOW()
      updatedAt: DateTime.now(), // Sera mis à jour par updateProfile
      avatarUrl: avatarUrl,
    );
    try {
      await _authService.updateProfile(userData);
      // Navigation is handled by onAuthStateChange in main.dart
      // if (!mounted) return;
      // _redirectToDashboardByRole(_defaultSignupRole); // Redundant if onAuthStateChange handles it
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erreur lors de la sauvegarde du profil: $e');
      debugPrint('Erreur sauvegarde profil dans _handleAuthResult: $e');
    }
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate() ||
        !_termsAccepted ||
        _selectedRole == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        // These userData are passed to Supabase Auth and stored in user_metadata
        userData: UserModel(
          id: '', // ID will be generated by Supabase Auth
          fullName: _nameController.text.trim(),
          role: _selectedRole!, // Utilise le rôle choisi
          phone: _phoneController.text.trim(),
          // Address is not a standard user_metadata field, will be handled by updateProfile
          avatarUrl: null,
        ),
      );

      // Manual insertion into 'users' table is removed.
      // _handleAuthResult and _authService.updateProfile will handle it.
      // This is called to ensure profile is updated with any additional fields not in user_metadata
      await _handleAuthResult(response);
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Erreur inconnue : $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signupWithGoogle() async {
    if (_selectedRole == null || !_termsAccepted) {
      setState(() => _errorMessage =
          'Veuillez choisir un rôle et accepter les conditions.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final AuthResponse response =
          (await _authService.signInWithGoogle()) as AuthResponse;
      final user = response.user;
      if (user != null) {
        await Supabase.instance.client.from('users').insert({
          'id': user.id,
          'email': user.email,
          'full_name': _nameController.text.trim(),
          'role': _selectedRole!,
          'phone': _phoneController.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      await _handleAuthResult(response, provider: 'google');
    } on AuthException catch (e) {
      setState(() => _errorMessage = 'Erreur Google sign-in : ${e.message}');
    } catch (e) {
      setState(() => _errorMessage = 'Erreur Google sign-in : $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGitHub() async {
    if (_selectedRole == null || !_termsAccepted) {
      setState(() => _errorMessage =
          'Veuillez choisir un rôle et accepter les conditions.');
      return;
    }

    setState(() {
        _isLoading = true;
        _errorMessage = null;
    });
    try {
      await _authService.signInWithGoogle();
      // OAuth flow initiated. Session and user data will be handled by onAuthStateChange.
      // Calling _handleAuthResult here is problematic as signInWithGoogle returns bool.
      // The selectedRole needs to be persisted or handled post-OAuth confirmation.
      // For now, we rely on onAuthStateChange for navigation.
      // The updateProfile for the role selected here needs a more robust solution.
    } on AuthException catch (e) {
      setState(() => _errorMessage = 'Erreur GitHub sign-in : ${e.message}');
    } catch (e) {
      setState(() => _errorMessage = 'Erreur GitHub sign-in : $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _redirectToDashboardByRole(String role) {
    switch (role) {
      case 'admin':
        context.goNamed('adminDashboard');
        break;
      case 'teacher':
        context.goNamed('teacherDashboard');
        break;
      case 'student':
      default:
        context.goNamed('studentDashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('signup_title'.tr()),
        centerTitle: true,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: context.locale,
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
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'signup_welcome'.tr(),
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "signup_subtitle".tr(),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'signup_fullname'.tr(),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'signup_fullname_required'.tr()
                              : null,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'signup_email'.tr(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'signup_email_required'.tr();
                        }
                        final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'signup_email_invalid'.tr();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'signup_phone'.tr(),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.telephoneNumber],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'signup_address'.tr(),
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.fullStreetAddress],
                    ),
                    const SizedBox(height: 16),
                    // Sélecteur de rôle
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0, left: 2.0),
                        child: Text(
                          'signup_role'.tr(),
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'student',
                            groupValue: _selectedRole,
                            onChanged: _isLoading
                                ? null
                                : (value) =>
                                    setState(() => _selectedRole = value),
                            title: Text('signup_role_student'.tr()),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'teacher',
                            groupValue: _selectedRole,
                            onChanged: _isLoading
                                ? null
                                : (value) =>
                                    setState(() => _selectedRole = value),
                            title: Text('signup_role_teacher'.tr()),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedRole == null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          child: Text(
                            'signup_role_required'.tr(),
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'signup_password'.tr(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'signup_password_required'.tr();
                        }
                        if (value.length < 6) {
                          return 'signup_password_length'.tr();
                        }
                        return null;
                      },
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordConfirmController,
                      decoration: InputDecoration(
                        labelText: 'signup_password_confirm'.tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'signup_password_confirm_required'.tr();
                        }
                        if (value != _passwordController.text) {
                          return 'signup_passwords_no_match'.tr();
                        }
                        return null;
                      },
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (val) =>
                              setState(() => _termsAccepted = val ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                                () => _termsAccepted = !_termsAccepted),
                            child: RichText(
                              text: TextSpan(
                                text: 'signup_terms_1'.tr(),
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: 'signup_terms_2'.tr(),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'signup_terms_3'.tr(),
                                  ),
                                  TextSpan(
                                    text: 'signup_terms_4'.tr(),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!_termsAccepted)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          child: Text(
                            'signup_terms_required'.tr(),
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.person_add),
                        label: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text('signup_button'.tr()),
                        onPressed: _isLoading ? null : _signup,
                      ),
                    ),
                    const SizedBox(height: 24),
// Séparateur avec texte centré
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "signup_or".tr(), // ou "Ou continuer avec"
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
                            onPressed:
                                _isLoading ? null : () => _signupWithGoogle(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
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
                            onPressed:
                                _isLoading ? null : () => signInWithGitHub(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
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
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('signup_already_account'.tr()),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  context.goNamed('login'); // Utiliser la route nommée
                                },
                          child: Text('signup_login'.tr()),
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
    );
  }
}
